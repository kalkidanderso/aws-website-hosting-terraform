# Website Hosting on AWS - Terraform Challenge

## Two hosting approaches

### 1. S3 + CloudFront (primary recommendation)
A static site bucket served through a CloudFront distribution using Origin
Access Control, so the bucket itself stays fully private.

**Why this one:** for a static (or mostly static) website this is the
cheapest and lowest-maintenance option. No servers to patch, scales
automatically with traffic, and CloudFront gives you HTTPS, edge caching,
and a stable global endpoint for free. Cache invalidation on deploy handles
the "auto redeployment" requirement.

### 2. EC2 + nginx
A single EC2 instance running nginx behind a security group, with an
Elastic IP attached so the address never changes across redeploys.

**Why this one:** included to demonstrate compute-based hosting, useful if
the site needs server-side logic, custom nginx config, or a reverse proxy
to a backend in the future. An Elastic IP solves the "stable endpoint"
requirement here since a plain EC2 public IP changes on stop/start.

### Why not the alternatives
- **ECS/Fargate or Elastic Beanstalk**: more moving parts (clusters,
  task definitions, load balancers) than a simple website needs. Good
  fit if the site becomes a containerized app with multiple services,
  overkill for now.
- **Amplify**: handles a lot of this automatically (hosting + CI), but
  hides the underlying Terraform-manageable resources, which works
  against the goal of this exercise.

## Requirements checklist

- **Terraform infrastructure**: all resources (S3, CloudFront, EC2,
  security groups, EIP) are defined as Terraform modules under `modules/`.
- **Remote state**: S3 backend with DynamoDB locking, configured per
  environment in `environments/<env>/backend.tf`. State buckets/lock
  tables are assumed to be created once via a small bootstrap step
  (not included, to avoid a chicken-and-egg dependency).
- **Auto redeployment**: GitHub Actions workflow (`.github/workflows/deploy.yml`)
  syncs `html/` to S3 and invalidates the CloudFront cache on every push
  to `main`.
- **Stable endpoints**: CloudFront distribution domain name is stable
  across redeploys (only content changes, not the distribution). EC2 uses
  an Elastic IP for the same reason.
- **TLS**: optional ACM certificate variable wired into the CloudFront
  distribution. If no certificate is supplied, CloudFront's default
  certificate is used (still HTTPS, just on the `*.cloudfront.net` domain).
- **Multi-account support**: `environments/dev` and `environments/prod`
  are separate root modules with their own backend, AWS profile/credentials,
  and `terraform.tfvars`. Both call the same shared modules, so
  infrastructure logic stays in one place while account-specific values
  (bucket names, SSH key names, region, domain) differ per environment.
- **CI setup**: GitHub Actions runs `terraform plan` on PRs and
  `terraform apply` + content sync on merges to `main` for the dev account.
  The same job structure can be duplicated for prod with its own secrets
  and a manual approval gate.

## Structure

```
modules/
  s3-cloudfront/   # static site bucket + CDN
  ec2-nginx/       # EC2 instance + nginx + EIP
environments/
  dev/             # dev account root module
  prod/            # prod account root module
html/              # sample site content
.github/workflows/ # CI/CD
```

## Usage

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with real bucket name, SSH key, etc.
terraform init
terraform plan
terraform apply
```

Repeat in `environments/prod` with a different AWS profile/account and its
own `terraform.tfvars`.

## Notes / honest caveats

This was built as a focused exercise to demonstrate structure, the
multi-account pattern, and how the pieces fit together rather than as a
fully hardened production setup. Given more time I'd add: a bootstrap stack
for the state backend itself, WAF on CloudFront, an ASG instead of a single
EC2 instance for the second approach, and a prod CI job with a manual
approval step before apply.
