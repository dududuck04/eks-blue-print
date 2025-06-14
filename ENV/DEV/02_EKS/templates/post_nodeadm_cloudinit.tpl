## template: jinja
#!/bin/bash

# EC2 Name Tag
EC2_IP="{{ ds.meta_data.local_ipv4|replace(".", "-") }}"
