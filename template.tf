#--------------------------------------------------------
# change vars in template to IP addresses and FQDNS for RKE
#--------------------------------------------------------
data "template_file" "rancher" {
  template = "${file("${path.root}/rancher-cluster-template.tpl")}"

  vars {
    ip-add1 = "${aws_instance.rancher-instance-1.public_ip}"  # ip address of each instance for RKE
	ip-add2 = "${aws_instance.rancher-instance-2.public_ip}"
	ip-add3 = "${aws_instance.rancher-instance-3.public_ip}"
	FQDNS = "${var.route53-name}"                             # A record name from route53 for RKE to use
	key-path = "${var.rancher-key-path}"                          # path to the pem file
  }
}
#--------------------------------------------------------
# output the rendered file to a yaml file
#--------------------------------------------------------
resource "local_file" "rke-template" {
    content     = "${data.template_file.rancher.rendered}"
    filename = "${path.root}/rancher-cluster.yaml"
}

#--------------------------------------------------------
# output the rendered file to a variable for troubleshooting
#--------------------------------------------------------
 output "rendered" {
  value = "${data.template_file.rancher.rendered}"
					}
					
					