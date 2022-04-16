# certbot
This container lets you manage a [certbot](https://pypi.org/project/certbot/)
system. When the container starts it just goes into a loop that checks to every
four hours see if any certificates need to be renewed. You can exec into it to
run renewals manually or create new certificates.

## Notes

This container prioritizes the Amazon Web Services Route 53 DNS Authenticator
for performing the ACME challenge that certbot requires. You can change this by
changing the `FROM` line in `Dockerfile` to match the base that you'd like to
use and rebuilding the container.

## Running on Docker

This container does not need to listen on any ports but it does need at least
two volumes mounted.

    docker build -t ghcr.io/paullockaby/certbot:latest .
    docker run --rm -it -v $PWD/data:/etc/letsencrypt -v $PWD/logs:/var/log/letsencrypt ghcr.io/paullockaby/certbot:latest renew

That is, you need to mount a directory for `/etc/letsencrypt` and
`/var/log/letsencrypt`. If you have renewal hooks that you want to run then you
should also mount `/etc/letsencrypt/renewal-hooks` and then put your hooks into
one of the `post`, `pre`, or `deploy` directories under that.

## Creating a Certificate

To use this container to interact with certbot or to create a certificate, call
it like this:

    docker run --rm -it -v $PWD/data:/etc/letsencrypt -v $PWD/logs:/var/log/letsencrypt ghcr.io/paullockaby/certbot:latest \
        certbot certonly --test-cert --dry-run -m noreply@example.org --agree-tos --no-eff-email --dns-route53 -d example.com

This will put a new certificate in place under `$PWD/data`. You should
definitely look at setting up a post hook to then deploy that certificate
somewhere. (Note that scripts in the `renewal-hooks` directory will _not_ be
run on a call to `certonly`. They only get run on calls to `renew`. That is to
say that you should manually run any hooks that you want to run after calling
`certonly` to create a new certificate.)

## Using With Kubernetes

If you're running the `renew` loop on a Kubernetes cluster somewhere and you
have a volume with your certificates on it, you can create a new certificate by
`exec`ing into the container and telling it to create new certificates, like
this:

    POD=$(kubectl get pods -l service=certbot -o jsonpath="{.items[0].metadata.name}")
    kubectl exec -it -c certbot $POD -- certbot ...

Obviously, replace the `...` with the command that you wish to send to the
certbot program.
