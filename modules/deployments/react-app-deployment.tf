resource "kubernetes_deployment" "react_app" {
  metadata {
    name      = "${var.react_app_name}"
    namespace = "${kubernetes_namespace.namespace.id}"
    labels {
      app     = "${var.react_app_name}"
    }
  }

  spec {
    replicas  = 2

    selector {
      match_labels {
        app         = "${var.react_app_name}"
      }
    }

    template {
      metadata {
        namespace   = "${kubernetes_namespace.namespace.id}"
        labels {
          app       =  "${var.react_app_name}"
        }
      }

      spec {
        container {
          image   = "${var.react_app_image}"
          name    = "${var.react_app_name}"
          port {
            container_port  = "${var.react_app_container_port}"
            name            = "http"
          }
          image_pull_policy = "Always"
          resources {
            requests {
              cpu     = "100m"
              memory  = "64Mi"
            }
            limits {
              cpu     = "100m"
              memory  = "64Mi"
            }
          }
          liveness_probe {
            http_get {
              path  = "/"
              port  = "http"
            }
            initial_delay_seconds  = "10"
          }

        }
      }
    }
  }
}
