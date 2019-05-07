resource "kubernetes_service" "react_app" {
  metadata {
    name              = "${var.react_app_name}"
    namespace         = "${kubernetes_namespace.namespace.id}"
  }

  spec {
    selector {
      app               = "${kubernetes_deployment.react_app.metadata.0.labels.app}"
    }
    
    port {
        port            = "3000"
        target_port     = "http"
        name            = "http"
        protocol        = "TCP"
    }
    type              = "LoadBalancer"
  }
}