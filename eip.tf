resource "aws_eip" "bastion" {
  count    = var.server_count["bastion"]
  instance = element(aws_instance.bastion.*.id, count.index)
  vpc      = true

  tags = {
    Name = "bastion-eks-${var.env}-${count.index}"
  }
}
