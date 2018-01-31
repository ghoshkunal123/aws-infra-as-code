resource "null_resource" "lambda" {
  # this local-exec creates *_upload.zip to be used by the below lambda resources.
  provisioner "local-exec" {
    command = "cd lambda_py && zip ../lambda_func/stop_ec2_upload.zip stop_ec2.py && cd .."
  }
  provisioner "local-exec" {
    command = "cd lambda_py && zip ../lambda_func/start_ec2_upload.zip start_ec2.py && cd .."
  }
}
resource "aws_lambda_function" "stop_ec2" {
    depends_on = ["null_resource.lambda"]
    function_name = "fngn-fqa-abba-stopEC2"
    handler = "stop_ec2.handler"
    runtime = "python3.6"
    filename = "lambda_func/stop_ec2_upload.zip"
    source_code_hash = "${base64sha256(file("lambda_func/stop_ec2_upload.zip"))}"
    role = "${var.lambda_role}"
}
resource "aws_lambda_function" "start_ec2" {
    depends_on = ["null_resource.lambda"]
    function_name = "fngn-fqa-abba-startEC2"
    handler = "start_ec2.handler"
    runtime = "python3.6"
    filename = "lambda_func/start_ec2_upload.zip"
    source_code_hash = "${base64sha256(file("lambda_func/start_ec2_upload.zip"))}"
    role = "${var.lambda_role}"
}
