# ------------------------------------------------------
# MAIN
# ------------------------------------------------------
aws_region            = "eu-west-1"
vpc_cidr               = "192.168.0.0/16"
country                = "es"
product_environment    = "pro"
aws_availability_zones = ["eu-west-1a","eu-west-1b","eu-west-1c"]
public_subnets         = ["192.168.0.0/28","192.168.1.0/28","192.168.2.0/28","192.168.0.16/28","192.168.1.16/28","192.168.2.16/28","192.168.0.32/28","192.168.1.32/28","192.168.2.32/28"]

# ------------------------------------------------------
# VPN
# ------------------------------------------------------
enable_vpn                       = true
vpn_customer_gateway_ip          = "195.55.73.228"
vpn_psk                          = "kXkopEY0CuhJzICmhNGKospMeKzEmJI4"
vpn_customer_routes_destinations = ["10.201.0.95/32"]
vpn_ike_version                  = ["ikev2"]
vpn_phase1_encryption_algorithms = ["AES128"]
vpn_phase1_integrity_algorithms  = ["SHA2-256"]
vpn_phase1_dh_group_numbers      = [14]
vpn_phase1_lifetime_seconds      = 28800
vpn_phase2_encryption_algorithms = ["AES128"]
vpn_phase2_integrity_algorithms  = ["SHA2-256"]
vpn_phase2_dh_group_numbers      = [14]
vpn_phase2_lifetime_seconds      = 3600

# ------------------------------------------------------
# DLM
# ------------------------------------------------------
snapshot_dlm_policies = {
  main = {                                    ### DLM policy name
    target_tags = { Snapshot = true }         ### tags for volume selection for snapshot
    tags_to_add = { SnapshotCreator = "DLM" } ### tags to add to the snapshots
    enabled     = true
    schedules = {
      every-6h-retain-15 = ["00:00", 6, 15, true] ### [times "01:00,03:30,18:30" ,interval-hours, retention-count, copy_tags_from_original_volume]
    }
  }
}

# ------------------------------------------------------
# EC2
# ------------------------------------------------------
forti_instances = { ### some cases if values are "" or null then it get forti_instances_default_conf values
  fortianalyzer_01 = {
    instance_type              = "fortianalyzer"
    secure_instance_id         = null ###  ["" | null | secure_id] if empty | null use random_id resource generated. Other case use secure_id
    network_private_ip_hostnum = 4
    permanent_eip              = true
    compute_instance_type      = null
    compute_ami                = null
    base_storage_conf          = null
    extra_storage_conf         = null
    sg_rules                   = null
    serial_number              = "22000528"
  }
  fortimanager_01 = {
    instance_type              = "fortimanager"
    secure_instance_id         = null
    network_private_ip_hostnum = 4
    permanent_eip              = true
    compute_instance_type      = null
    compute_ami                = null
    base_storage_conf          = null
    extra_storage_conf         = null
    sg_rules                   = null
    serial_number              = "22000711"
  }
  fortiportal_01 = {
    instance_type              = "fortiportal"
    secure_instance_id         = null
    network_private_ip_hostnum = 4
    permanent_eip              = false
    compute_instance_type      = null
    compute_ami                = null
    base_storage_conf          = null
    extra_storage_conf         = null
    sg_rules                   = null
    serial_number              = "1"
  }
}

forti_instances_default_conf = {
  fortianalyzer = { ###  [ "fortianalyzer" | "fortimanager" | "fortiportal"]
    network_subnet_newbits     = 12
    network_subnet_netnum      = 0
    network_private_ip_hostnum = 4
    permanent_eip              = true ### [true|false] elastic ip permanent resource
    compute_instance_type      = "m5.8xlarge"
    compute_ami = {
      eu-west-1    = "ami-0f8b8035f2342e09c"
      eu-central-1 = "ami-0b40af21e0bc10703"
    }
    base_storage_conf = {
      root = [4, "gp3", true, true, true, "storage-root", ""]               ###  [size, storage_type, encrypted, delete_on_termination, snapshot, tags_name_suffix, device_name]
      data = [300, "gp3", true, true, true, "storage-data-sdb", "/dev/sdb"] ### AMI mandatory volume as a minimum 80GB
    }
    extra_storage_conf = {
      data-sdc = [6200, "gp3", true, true, "storage-data-sdc", "/dev/sdc"]
      } ### eg: data-sdc = [20, "gp3", true, true, "storage-data-sdc", "/dev/sdc"] ###  [size, storage_type, encrypted, snapshot, tags_name_suffix, device_name]
    sg_rules = {            ###  [i/o "ingress|egress" , cidr_block "cidr|any" , from_port|icmp_type "port|type" , to_port|icmp_code "port|code", proto "tcp|udp|icmp|-1|all" , desc]
      "8-icmp-in"   = ["ingress", "10.201.0.95/32", 8, 0, "icmp", "ICMP SNMP monitoring woku"],
      "22-tcp-in"   = ["ingress", "10.201.0.95/32", 22, 22, "tcp", "SSH support access"],
      "161-udp-in"  = ["ingress", "10.201.0.95/32", 161, 161, "udp", "Woku integration"],
      "443-tcp-in"  = ["ingress", "any", 443, 443, "tcp", "HTTPS admin access"],
      "514-udp-in"  = ["ingress", "any", 514, 514, "udp", "Syslog"],
      "514-tcp-in"  = ["ingress", "any", 514, 514, "tcp", "Syslog"],
      "541-tcp-in"  = ["ingress", "any", 541, 541, "tcp", "FGTs mgmt"],
      "any-eg"   = ["egress", "any", 0, 0, "-1", "Any egress traffic"]
    }
    serial_number  = ""
  },
  fortimanager = {
    network_subnet_newbits     = 12
    network_subnet_netnum      = 1
    network_private_ip_hostnum = 4
    permanent_eip              = true
    compute_instance_type      = "m4.10xlarge"
    compute_ami = {
      eu-west-1    = "ami-07cbcd639c7485077"
      eu-central-1 = "ami-0e9f35158d219e517"
    }
    base_storage_conf = {
      root = [4, "gp3", true, true, true, "storage-root", ""]
      data = [300, "gp3", true, true, true, "storage-data-sdb", "/dev/sdb"] ### AMI mandatory volume as a minimum 80GB
    }
    extra_storage_conf = {
      data-sdc = [300, "gp3", true, true, "storage-data-sdc", "/dev/sdc"]
      }
    sg_rules = {
      "8-icmp-in"   = ["ingress", "10.201.0.95/32", 8, 0, "icmp", "ICMP SNMP monitoring woku"],
      "22-tcp-in"   = ["ingress", "10.201.0.95/32", 22, 22, "tcp", "SSH support access"],
      "53-udp-in"   = ["ingress", "any", 53, 53, "udp", "WebFilter queries, AV & IPS update"],
      "53-tcp-in"   = ["ingress", "any", 53, 53, "tcp", "WebFilter queries, AV & IPS update"],
      "161-udp-in"  = ["ingress", "10.201.0.95/32", 161, 161, "udp", "Woku integration"],
      "443-tcp-in"  = ["ingress", "any", 443, 443, "tcp", "HTTPS admin access"],
      "541-tcp-in"  = ["ingress", "any", 541, 541, "tcp", "FGTs mgmt"],
      "8888-udp-in" = ["ingress", "any", 8888, 8888, "udp", "WebFilter queries, AV & IPS updates"],
      "8888-tcp-in" = ["ingress", "any", 8888, 8888, "tcp", "WebFilter queries, AV & IPS updates"],
      "8889-udp-in" = ["ingress", "any", 8889, 8889, "udp", "Antispam"],
      "8889-tcp-in" = ["ingress", "any", 8889, 8889, "tcp", "Antispam"],
      "8890-tcp-in" = ["ingress", "any", 8890, 8890, "tcp", "Registration for license validation and UTM updates (AV, IPS)"],
      "8891-tcp-in" = ["ingress", "any", 8891, 8891, "tcp", "AV, IPS, AntiSpam, WebFilter database updates con FortiGuard"],
      "8900-tcp-in" = ["ingress", "any", 8900, 8900, "tcp", "Registration for license validation and UTM updates (AV, IPS)"],
      "any-eg"   = ["egress", "any", 0, 0, "-1", "Any egress traffic"]
    }
    serial_number  = ""
  },
  fortiportal = {
    network_subnet_newbits     = 12
    network_subnet_netnum      = 2
    network_private_ip_hostnum = 4
    permanent_eip              = false
    compute_instance_type      = "m4.4xlarge"
    compute_ami = {
      eu-west-1    = "ami-07241fa31f39a2406"
      eu-central-1 = "ami-09c5043df6c1e69e5"
    }
    base_storage_conf = {
      root = [10, "gp3", true, true, true, "storage-root", ""]
      data = [600, "gp3", true, true, true, "storage-data-sdb", "/dev/sdb"] ### AMI mandatory volume as a minimum 80GB
    }
    extra_storage_conf = {}
    sg_rules = {
      "8-icmp-in"  = ["ingress", "10.201.0.95/32", 8, 0, "icmp", "ICMP SNMP monitoring woku"],
      "22-tcp-in"  = ["ingress", "any", 22, 22, "tcp", "SSH support access"],
      "161-udp-in" = ["ingress", "10.201.0.95/32", 161, 161, "udp", "Woku integration"],
      "443-tcp-in" = ["ingress", "any", 443, 443, "tcp", "HTTPS admin access"],
      "any-eg"   = ["egress", "any", 0, 0, "-1", "Any egress traffic"]
    }
    serial_number  = ""
  }
}

# ----------------------------------------------------------
# RDS
# ----------------------------------------------------------
fortiportal_db_conf = {
  instance_conf = {
    enable       = true                                                      ### Whether to create a database instance
    basic_conf   = ["fortiportal-db", "db.m6g.large", "3306", true, "admin"] ### [ db_instance_identifier, db_instance_class, db_port, multi_az, admin_username]
    storage_conf = ["20", "1000", true, "gp2", ""]                           ### [ init_storage_GB, max_storage_scale_GB (if 0 not scale), encrypted, storage_type, iops (only io1 storage_type)]
    security_access_conf = {
      public_access   = false
      allowed_sources = [] ### fortiportals always permitted  ### [cidr | "vpc" | " any"]*  Ex: ["vpc", "192.168.0.0/28"]   ["vpc", "any", "135.2.3.2/32"]
    }
  }
  engine_conf             = ["mariadb", "10.4.21"]                                 ### [ engine, engine_version]
  maintenance_backup_conf = ["Sun:00:00-Sun:03:00", "03:00-06:00", 35, true, true] ### [maintenance_window, backup_window, backup retention, db_instance_deletion_protection, delete_backups_after_db_termination]
  logging_conf            = [true, 60, "general", "error"]                         ### [enable_logging, monitoring_interval_secs, logs type to export to CloudWatch ["audit" | "error" | "general" | "slowquery"]* ]
}