locals {
  students = [
    for i in range(var.student_count) :
    format("student%02d", i + 1)
  ]

  student_credentials_raw = jsondecode(
    file(var.student_credentials_file)
  )

  student_credentials = {
    for student, credentials in local.student_credentials_raw :
    student => merge(
      credentials,
      {
        console_password_b64 = base64encode(
          credentials.console_password
        )
      }
    )
  }

  student_password_b64 = base64encode(
    random_password.student.result
  )

  formateur_public_key = file(
    pathexpand("~/.ssh/id_ed25519.pub")
  )
}