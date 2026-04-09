#!/usr/bin/env python3
"""
Extrai responses AMF e XML do arquivo de captura do mitmproxy (.mitm)
e salva em amf-cache/ para uso pelo servidor local.
"""

import sys
import os
import json
import zlib
import gzip
import re

try:
    from mitmproxy.io import FlowReader
    from mitmproxy.net.http import http1
except ImportError:
    print("Erro: mitmproxy nao encontrado. Rode: pip install mitmproxy")
    sys.exit(1)

input_file = sys.argv[1] if len(sys.argv) > 1 else "pvzonline.mitm"
amf_dir = "amf-cache"
xml_dir = "xml"

os.makedirs(amf_dir, exist_ok=True)
os.makedirs(xml_dir, exist_ok=True)

amf_count = 0
xml_count = 0
all_flows = []

print(f"Lendo {input_file}...")

with open(input_file, "rb") as f:
    reader = FlowReader(f)
    try:
        for flow in reader.stream():
            if not hasattr(flow, 'request') or not flow.response:
                continue

            host = flow.request.host or ""
            path = flow.request.path or ""
            method = flow.request.method

            # Filtra apenas requests do youkia
            if "youkia" not in host and "youkia" not in path:
                continue

            url = flow.request.pretty_url
            req_body = flow.request.content or b""
            resp_body = flow.response.content or b""
            content_type = flow.response.headers.get("content-type", "")

            all_flows.append({
                "url": url,
                "method": method,
                "path": path,
                "status": flow.response.status_code,
                "content_type": content_type,
                "req_size": len(req_body),
                "resp_size": len(resp_body),
            })

            # --- AMF: POST /pvz/amf/ ---
            if method == "POST" and "/pvz/amf" in path and len(resp_body) > 0:
                # Tenta extrair o nome do metodo do request AMF
                amf_method = None

                # Tenta decodificar o request para achar o nome do metodo
                try:
                    body = req_body
                    # Detecta gzip
                    if body[:2] == b'\x1f\x8b':
                        body = gzip.decompress(body)
                    # Detecta chunked (hex digits + \r\n)
                    elif re.match(rb'^[0-9a-fA-F]+\r\n', body):
                        unchunked = b""
                        while body:
                            crlf = body.find(b'\r\n')
                            if crlf == -1:
                                break
                            size = int(body[:crlf], 16)
                            if size == 0:
                                break
                            unchunked += body[crlf+2:crlf+2+size]
                            body = body[crlf+2+size+2:]
                        body = unchunked
                        if body[:2] == b'\x1f\x8b':
                            body = gzip.decompress(body)

                    # AMF0: header (2 bytes version) + headers count (2 bytes) + messages count (2 bytes)
                    # Cada message: target string (2 bytes length + string)
                    if len(body) >= 6:
                        # Pula version (2) + headers_count (2)
                        pos = 4
                        headers_count = int.from_bytes(body[2:4], 'big')
                        # Pula headers
                        for _ in range(headers_count):
                            if pos + 2 > len(body): break
                            name_len = int.from_bytes(body[pos:pos+2], 'big')
                            pos += 2 + name_len + 1  # name + must_understand
                            val_len = int.from_bytes(body[pos:pos+4], 'big')
                            pos += 4 + val_len

                        # Messages count
                        if pos + 2 <= len(body):
                            msgs_count = int.from_bytes(body[pos:pos+2], 'big')
                            pos += 2
                            if msgs_count > 0 and pos + 2 <= len(body):
                                target_len = int.from_bytes(body[pos:pos+2], 'big')
                                pos += 2
                                if pos + target_len <= len(body):
                                    amf_method = body[pos:pos+target_len].decode('utf-8', errors='replace')
                except Exception as e:
                    pass

                if amf_method:
                    # Sanitiza o nome do metodo para filename
                    safe_name = amf_method.replace(".", "_").replace("/", "_")
                    req_path = os.path.join(amf_dir, f"{safe_name}_req.bin")
                    resp_path = os.path.join(amf_dir, f"{safe_name}_resp.bin")

                    with open(req_path, "wb") as out:
                        out.write(req_body)
                    with open(resp_path, "wb") as out:
                        out.write(resp_body)

                    print(f"  AMF: {amf_method} (req={len(req_body)}b resp={len(resp_body)}b)")
                    amf_count += 1
                else:
                    # Salva sem nome de metodo
                    idx = amf_count
                    with open(os.path.join(amf_dir, f"unknown_{idx}_req.bin"), "wb") as out:
                        out.write(req_body)
                    with open(os.path.join(amf_dir, f"unknown_{idx}_resp.bin"), "wb") as out:
                        out.write(resp_body)
                    print(f"  AMF (metodo desconhecido): req={len(req_body)}b resp={len(resp_body)}b")
                    amf_count += 1

            # --- XML: GET endpoints XML ---
            elif method == "GET" and ("xml" in content_type or resp_body.strip().startswith(b"<?xml") or resp_body.strip().startswith(b"<")):
                if len(resp_body) > 10:
                    # Gera nome baseado no path
                    safe_path = path.strip("/").replace("/", "_").replace("?", "_").replace("&", "_")
                    if not safe_path:
                        safe_path = "root"
                    safe_path = safe_path[:80]  # limita tamanho
                    xml_path = os.path.join(xml_dir, f"captured_{safe_path}.xml")
                    with open(xml_path, "wb") as out:
                        out.write(resp_body)
                    print(f"  XML: {path} ({len(resp_body)}b)")
                    xml_count += 1

    except Exception as e:
        print(f"Aviso: erro ao ler flows: {e}")

# Salva resumo de todos os flows capturados
summary_path = "mitm_flows_summary.json"
with open(summary_path, "w", encoding="utf-8") as f:
    json.dump(all_flows, f, indent=2, ensure_ascii=False)

print()
print(f"Concluido!")
print(f"  AMF capturados: {amf_count} -> amf-cache/")
print(f"  XMLs capturados: {xml_count} -> xml/")
print(f"  Resumo completo: {summary_path}")
print()
print("Metodos AMF encontrados em amf-cache/:")
for f in sorted(os.listdir(amf_dir)):
    if f.endswith("_resp.bin"):
        print(f"  {f.replace('_resp.bin', '')}")
