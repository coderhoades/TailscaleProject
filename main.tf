terraform {
  required_providers {
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.16"
    }
  }
}

provider "tailscale" {
  tailnet = var.tailnet
}

resource "tailscale_key" "demo_app" {
  reusable      = true
  ephemeral     = false
  preauthorized = true
  tags          = ["tag:demotag"]
}

resource "tailscale_acl" "demo_policy" {
  acl = file("${path.module}/tailnet-policy.hujson")
}