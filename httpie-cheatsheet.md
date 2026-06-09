# HTTPie Cheatsheet

## Basic Syntax

```bash
http [METHOD] URL [ITEM...]
```

---

## HTTP Methods

```bash
http GET    https://api.example.com/users
http POST   https://api.example.com/users
http PUT    https://api.example.com/users/1
http PATCH  https://api.example.com/users/1
http DELETE https://api.example.com/users/1
```

> `GET` is the default if no method is specified.

---

## Sending Data

### JSON (default for POST/PUT/PATCH)
```bash
http POST api.example.com/users name="John" age:=30
```
- `key=value`   → string
- `key:=value`  → raw JSON (numbers, booleans, arrays, objects)

### Form data
```bash
http --form POST api.example.com/login username="john" password="secret"
# or shorthand
http -f POST api.example.com/login username="john" password="secret"
```

### Raw JSON body
```bash
echo '{"name": "John"}' | http POST api.example.com/users
```

### From a file
```bash
http POST api.example.com/users < data.json
cat data.json | http POST api.example.com/users
```

---

## Headers

```bash
http GET api.example.com/users Authorization:"Bearer token123" Accept:application/json
```

- `Header:Value` → sets a header

---

## Query Parameters

```bash
http GET api.example.com/users search==john page==2
```

- `param==value` → appends `?param=value` to the URL

---

## Authentication

### Basic auth
```bash
http -a username:password GET api.example.com/users
# or
http --auth username:password GET api.example.com/users
```

### Bearer token
```bash
http GET api.example.com/users Authorization:"Bearer <token>"
```

### Digest auth
```bash
http --auth-type=digest -a username:password GET api.example.com/users
```

---

## Sessions

```bash
# Save session (cookies, auth, headers)
http --session=./session.json POST api.example.com/login username="john" password="secret"

# Reuse session
http --session=./session.json GET api.example.com/profile
```

---

## File Upload

```bash
http --form POST api.example.com/upload file@/path/to/file.jpg
```

---

## Output Control

```bash
http --headers GET api.example.com     # response headers only
http --body GET api.example.com        # response body only
http --verbose GET api.example.com     # request + response (full)
http --print=HBhb GET api.example.com  # custom: H=req headers, B=req body, h=res headers, b=res body
```

### Download a file
```bash
http --download GET api.example.com/file.zip
# or shorthand
http -d GET api.example.com/file.zip
```

---

## TLS / SSL

```bash
http --verify=no GET https://self-signed.example.com    # skip SSL verification
http --cert=client.crt --cert-key=client.key GET https://api.example.com
```

---

## Proxy

```bash
http --proxy=http:http://proxy.example.com:8080 GET api.example.com
```

---

## Timeouts

```bash
http --timeout=5 GET api.example.com    # 5 second timeout
```

---

## Redirects

```bash
http --follow GET api.example.com       # follow redirects
```

---

## Offline / Dry Run

```bash
http --offline POST api.example.com/users name="John"   # print request, don't send
```

---

## Common Shorthand

| Long flag        | Short | Description              |
|------------------|-------|--------------------------|
| `--form`         | `-f`  | Form data encoding        |
| `--auth`         | `-a`  | Authentication            |
| `--verbose`      | `-v`  | Full request + response   |
| `--headers`      | `-h`  | Response headers only     |
| `--body`         | `-b`  | Response body only        |
| `--download`     | `-d`  | Download response to file |
| `--session`      |       | Session file              |
| `--verify=no`    |       | Skip SSL verification     |
| `--follow`       |       | Follow redirects          |
| `--offline`      |       | Dry run (no request sent) |

---

## Quick Examples

```bash
# GET with query params and header
http GET api.example.com/search q==httpie Accept:application/json

# POST JSON
http POST api.example.com/users name="Alice" role="admin" active:=true

# PUT with auth
http -a admin:secret PUT api.example.com/users/1 name="Bob"

# DELETE
http DELETE api.example.com/users/1

# Upload file
http --form POST api.example.com/upload avatar@photo.jpg

# Save response to file
http GET api.example.com/data > output.json
```
