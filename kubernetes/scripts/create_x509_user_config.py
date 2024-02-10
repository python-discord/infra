import argparse
import base64
import shutil
import subprocess  # noqa: S404
import tempfile
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("user", help="The name to give the created user")
parser.add_argument("--role_binding", help="The role binding to add this user to", default="devops-reader")
args = parser.parse_args()
user = args.user
role_binding = args.role_binding

CERT_REQUEST_TEMPLATE = """apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: {user}
spec:
  groups:
  - system:authenticated
  request: {req}
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
"""
ROLE_BINDING_PATCH_TEMPLATE = """[
    {{
        "op": "add",
        "path": "/subjects/0",
        "value": {{
            "kind": "User",
            "name": "{user}"
        }}
    }}
]
"""  # noqa: RUF027


def run_and_return_output(command: str, cwd: str | None = None) -> str:
    """Run a command in a shell and return the result as a string."""
    return subprocess.run(
        command,  # noqa: S603
        stdout=subprocess.PIPE,
        text=True,
        check=True,
        cwd=cwd,
    ).stdout


def create_cert_signing_request(tmpdir: str) -> str:
    """Create and return a CertificateSigningRequest."""
    run_and_return_output("openssl genrsa -out priv.key 2048", tmpdir)
    cert_req = run_and_return_output(
        f"openssl req -new -key priv.key -subj /C=GB/ST=GB/O=pydis/CN={user}",
        tmpdir,
    )
    return base64.b64encode(cert_req.encode("utf-8")).decode("utf-8").replace("\n", "")


def approve_cert_signing_request(csr: str, tmpdir: str) -> None:
    """Approve the csr and save as a file in tmpdir."""
    csr_path = Path(tmpdir, "csr.yml")
    with csr_path.open("w") as f:
        f.write(CERT_REQUEST_TEMPLATE.format(user=user, req=csr))
    run_and_return_output(f"kubectl apply -f {csr_path}", tmpdir)
    run_and_return_output(f"kubectl certificate approve {user}")
    approved_cert = run_and_return_output(f"kubectl get csr {user} -o jsonpath='{{.status.certificate}}'")
    with Path(tmpdir, f"{user}.crt").open("w") as f:
        f.write(base64.b64decode(approved_cert).decode("utf-8"))
    run_and_return_output(f"kubectl delete csr {user}")


def give_user_perms(tmpdir: str) -> None:
    """Add the user from args to the cluster role binding from the args."""
    role_binding_patch_path = Path(tmpdir, "binding_patch.json")
    with role_binding_patch_path.open("w") as f:
        f.write(ROLE_BINDING_PATCH_TEMPLATE.format(user=user))
    run_and_return_output(
        f"kubectl patch clusterrolebinding {role_binding} --type=json --patch-file {role_binding_patch_path}",
        tmpdir,
    )


def build_kubectl_config(tmpdir: str) -> None:
    """Build up a kubectl config from all the files in the tmpdir."""
    cluster_public_key = run_and_return_output(r"kubectl get cm kube-root-ca.crt -o jsonpath={['data']['ca\.crt']}")
    with Path(tmpdir, "ca.crt").open("w") as f:
        f.write(cluster_public_key)
    cluster_url = run_and_return_output("kubectl config view --minify --output jsonpath={.clusters[*].cluster.server}")

    run_and_return_output(
        f"kubectl config set-cluster pydis --kubeconfig={user}.config "
        f"--server={cluster_url} --certificate-authority=ca.crt --embed-certs=true",
        tmpdir,
    )
    run_and_return_output(
        f"kubectl config set-credentials {user} "
        f"--client-key=priv.key --client-certificate={user}.crt "
        f"--embed-certs=true --kubeconfig={user}.config",
        tmpdir,
    )
    run_and_return_output(
        f"kubectl config set-context pydis --kubeconfig={user}.config "
        f"--cluster=pydis --user={user} --namespace=default",
        tmpdir,
    )
    run_and_return_output(f"kubectl config use-context pydis --kubeconfig={user}.config", tmpdir)


with tempfile.TemporaryDirectory() as tmpdir:
    csr = create_cert_signing_request(tmpdir)
    approve_cert_signing_request(csr, tmpdir)
    give_user_perms(tmpdir)
    build_kubectl_config(tmpdir)
    # Move the kubectl config from tmpdir to the current working dir ready to be sent to user.
    shutil.copy(
        Path(tmpdir, f"{user}.config"),  # from
        Path(f"{user}.config"),  # to
    )
    print(f"Config generated. Saved to {user}.config in current directory.")  # noqa: T201
