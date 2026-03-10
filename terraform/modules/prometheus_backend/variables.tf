variable "backend_mode" {
  description = "Backend mode: amp or oss"
  type        = string
  default     = "amp"

  validation {
    condition     = contains(["amp", "oss"], var.backend_mode)
    error_message = "backend_mode must be one of: amp, oss."
  }
}

variable "environment" {
  description = "Environment label"
  type        = string
}

variable "name_prefix" {
  description = "Global prefix for resource names"
  type        = string
  default     = "observability"
}

variable "team" {
  description = "Team ownership label"
  type        = string
  default     = "platform"
}

variable "tags" {
  description = "Additional resource tags"
  type        = map(string)
  default     = {}
}
