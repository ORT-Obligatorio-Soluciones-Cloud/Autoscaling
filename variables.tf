variable "vpc_id" {
  description = "ID del vpc"
  type = string
}

variable "private_subnet_ids" {
  description = "ID de las subredes privadas"
  type = list(string)
}

variable "alb_security_group_id" {
  description = "ID del security group del alb"
  type = string
}

variable "target_group_arn" {
  description = "ARN del target group"
  type = string
}

variable "public_subnet_ids" {
  description = "ID de las subredes publicas"
  type = list(string)
}

variable "db_endpoint" {
  description = "Endpoint de la base de datos"
  type = string
}

variable "db_password" {
  description = "Contraseña de la base de datos"
  type = string
}

variable "db_database" {
  description = "Nombre de la base de datos"
  type = string
}

variable "db_user" {
  description = "Usuario de la base de datos"
  type = string
}

variable "git_token" {
  description = "Token de GitHub para clonar el repositorio privado"
  type = string
}
