(list (channel
       (name 'sops-guix)
       (url "https://github.com/fishinthecalculator/sops-guix.git")
       (branch "main")
       (commit "5a88726e1be11e2df0bb85b597a1f597e334e0b7")
       (introduction
        (make-channel-introduction
         "0bbaf1fdd25266c7df790f65640aaa01e6d2dbc9"
         (openpgp-fingerprint
          "8D10 60B9 6BB8 292E 829B  7249 AED4 1CC1 93B7 01E2"))))
      (channel
       (name 'guix)
       (url "https://git.guix.gnu.org/guix.git")
       (branch "master")
       (commit "4750a7657d73e01d45789b06f4b8154b61da5f7f")
       (introduction
        (make-channel-introduction
         "9edb3f66fd807b096b48283debdcddccfea34bad"
         (openpgp-fingerprint
          "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))
