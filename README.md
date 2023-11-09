# tailscale-socks5

Create Tailscale Auth Key:
- Access: https://login.tailscale.com/admin/settings/keys
- Auth keys -> Generate auth key

![image](https://github.com/hypnguyen1209/tailscale-socks5/assets/33387061/9170f705-5b67-42e2-aac6-96d9ebe39123)

- Save this key to bind env `TAILSCALE_AUTHKEY`

![image](https://github.com/hypnguyen1209/tailscale-socks5/assets/33387061/21d3771f-6ad4-4081-9f6e-96e3eb048f28)

### Build and run container:

```bash
git clone https://github.com/hypnguyen1209/tailscale-socks5
cd tailscale-socks5
docker build -t hypnguyen1209/tailscale-socks5 .
```

Run with `TAILSCALE_AUTHKEY`

```bash
docker run -p 10800:1080 --env TAILSCALE_AUTHKEY=tskey-auth-xxx hypnguyen1209/tailscale-socks5
```

Test:

```bash
# curl to device in your tailnet. Example 100.78.16.70:8000/http
curl 100.83.134.154:8000 --proxy socks5h://127.0.0.1:10800
```

