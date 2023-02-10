resource "yandex_lb_target_group" "lbtg-1" {
  name = "lbtg-1"

  dynamic "target" {
    for_each = yandex_compute_instance_group.ig-1.instances
    content {
      subnet_id = target.value.network_interface.0.subnet_id
      address   = target.value.network_interface.0.ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "lb-1"
  listener {
    name = "listener-1"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = "${yandex_lb_target_group.lbtg-1.id}"
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
        }
    }
  }
}