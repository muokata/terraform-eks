data "template_file" "init-worker-eks" {
  template = file("user_data/bootstrap-eks.sh")
  vars = {
    cluster_auth_base64  = module.eks.cluster_certificate_authority_data
    endpoint             = module.eks.cluster_endpoint
    bootstrap_extra_args = ""
    kubelet_extra_args   = "--hostname-override $(hostname -s)"
    cluster_name         = module.eks.cluster_id
  }
}

data "template_file" "shell-worker-group-1" {
  template = file("user_data/worker-group-1.sh")
}

data "template_file" "init-worker-group-1" {
  template = file("user_data/worker-group-1.cfg")
}

data "template_file" "shell-worker-group-2" {
  template = file("user_data/worker-group-2.sh")
}

data "template_file" "init-worker-group-2" {
  template = file("user_data/worker-group-2.cfg")
}

data "template_cloudinit_config" "cloudinit-worker-group-1" {
  gzip          = false
  base64_encode = false

  part {
    content = data.template_file.shell-worker-group-1.rendered
  }

  part {
    content = data.template_file.init-worker-group-1.rendered
  }

  part {
    content = data.template_file.init-worker-eks.rendered
  }
}

data "template_cloudinit_config" "cloudinit-worker-group-2" {
  gzip          = false
  base64_encode = false

  part {
    content = data.template_file.shell-worker-group-2.rendered
  }

  part {
    content = data.template_file.init-worker-group-2.rendered
  }

  part {
    content = data.template_file.init-worker-eks.rendered
  }
}
