{
  pkgs,
  lib,
  config,
  ...
}: let
  host_translate = {
    host,
    port ? "22",
  }: [
    "[${host}]:${port}"
    "[${host}.gensokyo]:${port}"
    "[${host}.armadillo-banfish.ts.net]:${port}"
  ];
  isLinux = pkgs.stdenv.hostPlatform.isLinux == "linux";
  linuxOptions = {
    sudo.wheelNeedsPassword = false;
    pam.p11.enable = true;
    audit.enable = true;
  };
  darwinOptions = {
    pam.enableSudoTouchIdAuth = true;
  };
  securityOptions =
    if isLinux
    then linuxOptions
    else darwinOptions;
in {
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };
  programs.ssh.knownHosts = {
    "mokou" = {
      hostNames = host_translate {host = "mokou";};
      publicKeyFile = ./pubkeys/mokou.pub;
    };
    "bedford-kitchen-macmini" = {
      hostNames = host_translate {host = "bedford-kitchen-macmini";};
      publicKeyFile = ./pubkeys/bedford-kitchen-macmini.pub;
    };
    "bedford-media-macmini" = {
      hostNames = host_translate {host = "bedford-media-macmini";};
      publicKeyFile = ./pubkeys/bedford-media-macmini.pub;
    };
    "voile" = {
      hostNames = host_translate {host = "voile";};
      publicKeyFile = ./pubkeys/voile.pub;
    };
    "myon" = {
      hostNames = host_translate {host = "myon";};
      publicKeyFile = ./pubkeys/myon.pub;
    };
    "yukari" = {
      hostNames = host_translate {host = "yukari";};
      publicKeyFile = ./pubkeys/yukari.pub;
    };
    "yuyuko" = {
      hostNames = host_translate {host = "yuyuko";};
      publicKeyFile = ./pubkeys/yuyuko.pub;
    };
    "octopi" = {
      hostNames = host_translate {host = "octopi";};
      publicKeyFile = ./pubkeys/octopi.pub;
    };
    "beaglebone" = {
      hostNames = host_translate {host = "beaglebone";};
      publicKeyFile = ./pubkeys/beaglebone.pub;
    };
    "bedford-office-macmini" = {
      hostNames = host_translate {host = "bedford-office-macmini";};
      publicKeyFile = ./pubkeys/bedford-office-macmini.pub;
    };
    "ereshkigal" = {
      hostNames = host_translate {host = "ereshkigal";};
      publicKeyFile = ./pubkeys/ereshkigal.pub;
    };
    "razer" = {
      hostNames = host_translate {host = "razer";};
      publicKeyFile = ./pubkeys/razer.pub;
    };
    "github.com" = {
      hostNames = ["github.com"];
      publicKeyFile = ./pubkeys/github.pub;
    };
  };
  security =
    securityOptions
    // {
      pki.certificates = [
        ''
          Falseblue Root CA
          -----BEGIN CERTIFICATE-----
          MIIDUTCCAjmgAwIBAgIUIOEtFYWd5EogN4Lto5YMSvSpgdwwDQYJKoZIhvcNAQEL
          BQAwGDEWMBQGA1UEAwwNZmFsc2VibHVlLmNvbTAeFw0yMjA0MTMxNTIzNThaFw0z
          MjA0MTAxNTIzNThaMBgxFjAUBgNVBAMMDWZhbHNlYmx1ZS5jb20wggEiMA0GCSqG
          SIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7Lriwfw0Rn542MsD6UNMWrfhvCDQ9akaA
          6wcF2BOygZxKxbEjWbhjBAryh23e0IJC/aRHmoLg8zZjxCRezwOcKMgRmiVBncAw
          NyegS5rnd5JcSO0fYfT80vg7O1aJquICtOJ1fKypQjbdlqJmxDEdo02qwCLsM+y3
          ExBCe23KTK8llkRW9LdjwCpOAfZnKZnoULYWmwCJ2izgOfoPjYRhpUcF7OHxoDag
          R+TXy2BsSp4MCiFKc4f/J0Rd1aA+D1GMA53NN3qBkh+FJ1qAZgoc8FOG9d0AUptS
          Jd0JwhqDJCQJVwi4GL7Paejgcj+7OfYGxFRtkhQ5bWnH8NsYsLWRAgMBAAGjgZIw
          gY8wDAYDVR0TBAUwAwEB/zAdBgNVHQ4EFgQUyGQ+Hi6OCgNDxuf7mOvHyvPsJD8w
          UwYDVR0jBEwwSoAUyGQ+Hi6OCgNDxuf7mOvHyvPsJD+hHKQaMBgxFjAUBgNVBAMM
          DWZhbHNlYmx1ZS5jb22CFCDhLRWFneRKIDeC7aOWDEr0qYHcMAsGA1UdDwQEAwIB
          BjANBgkqhkiG9w0BAQsFAAOCAQEAYBSxEnBqFpLY5J5gDXVK/G2X8pexA+8Z8dZ4
          Plc2aVW6zCClhYLyCKTKCxFnpwbCPqCbq18/IMjUtEGNDLWY79CfYJBqM8T0/mz9
          PIt6pEPE6BdBv2bsyGP68qFK6LRvunPDt9jFoxpEmFNT4Rl/+hWDBDdZrb3JuI1J
          7sQZQ+b4j/93Kw7AgJdMQM7jec35J0byE/3i6Y7EwHXATKnhXoMUPI++oqCnH/vU
          BrMzWC22IyHtdVIL5YRlyaEBfwuwlYO1/ZbXRaiuO9sY5jLqSEmM3IrC80u+qLP4
          wOc99x4Ui7hmme27HZFlUrLqCkXRz7CEBcPg83lN37lGeaw0TQ==
          -----END CERTIFICATE-----
        ''

        ''
          Falseblue Intermediate CA Yubikey Nano5c
          -----BEGIN CERTIFICATE-----
          MIICozCCAYugAwIBAgIQFlveObzbab2nyOaDFw+RuzANBgkqhkiG9w0BAQsFADAY
          MRYwFAYDVQQDDA1mYWxzZWJsdWUuY29tMB4XDTI0MDIwNDEzMzQxMVoXDTI2MDUw
          OTEzMzQxMVowHDEaMBgGA1UEAwwRWXViaUtleSAtIE5hbm8gNWMwdjAQBgcqhkjO
          PQIBBgUrgQQAIgNiAARp1Lnx4HQ2N+9RY1aIsUen86lMB3hIG7EvOquhomOmejJW
          oDGRNuzbXqXeYwm3gZGGrIq3YQTsaoDcM2w5CACM6ysTfaL6htxq6PoTc13hEH/0
          rrNbDpNLquA6WyvE8mSjgZIwgY8wDAYDVR0TBAUwAwEB/zAdBgNVHQ4EFgQUCfGK
          SVS0o6tkNGaVyhuISp8RkjcwUwYDVR0jBEwwSoAUyGQ+Hi6OCgNDxuf7mOvHyvPs
          JD+hHKQaMBgxFjAUBgNVBAMMDWZhbHNlYmx1ZS5jb22CFCDhLRWFneRKIDeC7aOW
          DEr0qYHcMAsGA1UdDwQEAwIBBjANBgkqhkiG9w0BAQsFAAOCAQEAWcdRUTcfIolP
          yZK48nxzoMdkHCNSVl9rd/ciyjTNQIRcnG95OXCRFYiC6I9LgS58KhjEIX4Y50Wv
          4ZBopyYyJGcO3vFQQsRjisdFDzpdeOw7Q1xrx2ugpBSB0miqeu45EhPUXu0CiOkU
          tvcG8+CNT2ZcLGD4zRVJyYrzP4tsNvTK9z0BPurld/tbVd5bNU9o0o/lexolqxem
          d2HZnDTbjsJ1TQ+X6T5wrxsVBsbReKkw4OlxXbHf5lLzPFwqrJ6145aqwX/bOPda
          I96GKHOjc6Ny0DK+8C5rLzpiMKNxje4uCEQ+pOgmBRnzgsYYKoxB5n1EWuP1JlFf
          87ZxF8JAzw==
          -----END CERTIFICATE-----
        ''

        # ''
        #   Falseblue Intermediate CA Yubikey 5c NFC
        #   -----BEGIN CERTIFICATE-----
        #   MIIC/zCCAoagAwIBAgIIMTseeC7Qq1cwCgYIKoZIzj0EAwQwHDEaMBgGA1UEAwwR
        #   WXViaUtleSAtIE5hbm8gNWMwHhcNMjQwMjA1MjEzOTAwWhcNMjYwNTA5MTMzNDAw
        #   WjCCARoxCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJJTjESMBAGA1UEBxMJTGFmYXll
        #   dHRlMRIwEAYDVQQKEwlGYWxzZUJsdWUxETAPBgNVBAsTCEdlbnNva3lvMScwJQYD
        #   VQQDEx5ZdWJpa2V5IDVjIE5GQyAtIEtleWNoYWluIC0gQ0ExKDAmBgkqhkiG9w0B
        #   CQEWGWJlbmphbWluLmNyYXRvbkBnbWFpbC5jb20xETAPBgNVBCoTCEJlbmphbWlu
        #   MQ8wDQYDVQQEEwZDcmF0b24xHTAbBgNVBA0TFFl1YmlrZXkgc2lnbmluZyBjZXJ0
        #   MS0wKwYDVQRIEyRDQSBmb3IgaW50ZXJuYWwgYW5kIGZhbWlseSBlbmRwb2ludHMw
        #   djAQBgcqhkjOPQIBBgUrgQQAIgNiAAQAP4B1OuW4dfzOHG7/JGil/4gPBIzXhdky
        #   Pa8nOlMcIb6UAxqCWZp5Bnj3Za/4Fc8uYo15IBRubHxXr+CECjviWL+7Rt2tP6fF
        #   cibd2L1swfhLLRGMqw6Iuqp351/>eiyWjgZQwgZEwDwYDVR0TAQ>H/BAUwAwEB/zAd
        #   BgNVHQ4EFgQUhUOJjA6KcuS7WbNfyIgRDNwvq34wHwYDVR0jBBgwFoAUCfGKSVS0
        #   o6tkNGaVyhuISp8RkjcwCwYDVR0PBAQDAgEGMBEGCWCGSAGG+EIBAQQEAwIABzAe
        #   BglghkgBhvhCAQ0EERYPeGNhIGNlcnRpZmljYXRlMAoGCCqGSM49BAMEA2cAMGQC
        #   MAWETZqLLwVKRfHRfradDmKWre+j1ZT7sDXtW/Q8VktovWNh57haE3ZE12KCJErm
        #   RQIwG+qqsKARELPww6rhJdv3ELoRF8IbUdxh2wcAE3Ly4d3/84RV7hNo0TUe4Opg
        #   xx6+
        #   -----END CERTIFICATE-----
        # ''
      ];
    };
}
