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

resource "demo_key" "demo_app" {
  reusable      = false
  ephemeral     = false
  preauthorized = true
  tags          = ["tag:demo_key"]
}

resource "tailscale_acl" "demo_policy" {
  acl = file("${path.module}/tailnet-policy.hujson")
}