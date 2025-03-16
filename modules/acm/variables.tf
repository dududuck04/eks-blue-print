variable "env" {
  type        = string
  description = "개발환경"
}

variable "pjt" {
  type        = string
  description = "프로젝트 이름"
}

variable "acm_domains" {
  type        = string
  description = "acm"
}

variable "acm_sub_domains" {
  type        = list(any)
  description = "개발환경"
}


####################################################################################################
variable "zone_id" {
  type        = list(any)
  description = "개발환경"
  default     = null
}