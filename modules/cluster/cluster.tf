resource "google_container_cluster" "turing_cluster" {
    name                = "turing"
    location            = "${var.location}"
    network             = "${google_compute_network.turing_network.self_link}"
    subnetwork          = "${google_compute_subnetwork.turing_subnet.self_link}"
    node_pool           = [{
        name            = "default-pool"
        node_count      = 2

        autoscaling {
            min_node_count      = 2
            max_node_count      = 5
        }

        management {
            auto_upgrade        = true
        }
    }]
}