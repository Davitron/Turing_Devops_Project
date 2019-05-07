resource "google_compute_network" "turing_network" {
    name                    = "turing-network"
    auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "turing_subnet" {
    name                        = "turing-network-subnet"
    ip_cidr_range               = "10.0.0.0/16"
    region                      = "${var.region}"
    network                     = "${google_compute_network.turing_network.self_link}"
    private_ip_google_access    = "true"
}