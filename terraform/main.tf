provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace_v1" "btech-success-stories" {
  metadata {
    name = "btech-success-stories"
  }
}

# --------------------
# MongoDB Deployment
# --------------------
resource "kubernetes_deployment" "mongodb" {
  metadata {
    name      = "mongodb"
    namespace = kubernetes_namespace_v1.btech-success-stories.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mongodb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }

      spec {
        container {
          name  = "mongodb"
          image = "mongo:latest"

          port {
            container_port = 27017
          }
        }
      }
    }
  }
}

# --------------------
# MongoDB Service
# --------------------
resource "kubernetes_service_v1" "mongodb_service" {
  metadata {
    name      = "mongodb-service"
    namespace = kubernetes_namespace_v1.btech-success-stories.metadata[0].name
  }

  spec {
    selector = {
      app = "mongodb"
    }

    port {
      port        = 27017
      target_port = 27017
    }
  }
}