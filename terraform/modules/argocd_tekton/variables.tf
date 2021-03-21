variable "module_depends_on" {
  default     = [""]
  description = "Modules that are required to run before this module does"
  type        = list
}