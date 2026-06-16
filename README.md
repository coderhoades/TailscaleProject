# Tailscale Project

## Overview of the problem and the solution

One of the recurring challenges organizations face is providing temporary access to internal resources for contractors, consultants, implementation partners, and other third parties.

To better understand real-world use cases and prepare for this assignment, I spoke with a former enterprise customer at one of the largest financial institutions in the United States. During that discussion, contractor access emerged as a common pain point. Their teams regularly need to provide external users access to specific resources, but traditional VPN-based approaches often result in lengthy onboarding processes, broad network access, and increased security risk.

Having read the PDF assignment and acknowledging that the homework asked for something on the simpler side but with automation, I decided to use GitOps to manage the policy from Gitlab as in this real world example, the resources would already exist within the customer's environment.

This project demonstrates how Tailscale can be used to provide secure, identity-based access to internal resources based on user role rather than network location.

The solution consists of:

- A Tailscale Tailnet
- An internal documentation platform
- A production database
- An employee persona
- A privileged contractor persona
- A simple contractor persona
- ACL policies managed through a GitOps workflow and automatically synchronized into Tailscale

The goal is to demonstrate how organizations can apply least-privilege access controls while simplifying onboarding and offboarding workflows for temporary users.

Access is granted according to business need:

| User | Documentation Platform | Production Database |
|------------|------------|------------|
| Employee | ✅ | ✅ |
| Privileged Contractor | ✅ | ✅ |
| Simple Contractor | ✅ | ❌ |

This allows external users to access only the resources required for their engagement without granting broad VPN access to the entire environment.

## Architecture overview

https://mermaid.ai/d/bd687d87-6bca-4685-96b0-cccbf45644ae

The environment contains four primary components:

### Internal Documentation Platform

Represents an internal knowledge base or operational documentation portal.

Accessible by:

- Employees
- Privileged contractors
- Simple contractors

### Production Database

Represents a sensitive production resource requiring elevated access.

Accessible by:

- Employees
- Privileged contractors

Not accessible by:

- Simple contractors

### GitOps Policy Management

ACL policies are stored in GitHub and automatically synchronized into Tailscale.

This provides:

- Version control
- Auditability
- Change history
- Repeatable policy deployment

In a production environment, this allows access changes to be reviewed and approved before deployment.

### Infrastructure Scope

For this project, the applications already existed and the focus was intentionally placed on access control and policy management.

While the application infrastructure could also be provisioned through Terraform, I chose to focus on the portion of the workflow most directly related to the customer problem: securely granting and managing access to existing resources.

## Setup and deployment instructions

### Prerequisites

Before beginning, you'll need:

- A Tailscale account with administrative access
- A Tailnet
- A GitHub account
- Access to the existing applications being protected
- Access to the GitOps synchronization workflow

For this project, the Internal Documentation Platform and Production Database already exist. The focus of the implementation is access management and policy enforcement rather than application deployment.

---

### Clone the repository

```bash
git clone https://github.com/coderhoades/TailscaleProject.git
cd TailscaleProject
```

---

### Review the policy

The source of truth for access management is:

```text
policy.hujson
```

This file defines:

- User groups
- User personas
- Resource permissions
- Allowed and denied access paths

Review the policy to understand the intended authorization model.

---

### Deploy policy changes

Update the policy as needed and commit changes to GitHub.

```bash
git add .
git commit -m "Update contractor access policy"
git push
```

The GitOps workflow automatically synchronizes approved policy changes into Tailscale.

---

### Verify policy deployment

After synchronization completes:

- Open the Tailscale Admin Console
- Review the applied policy
- Confirm group membership and resource permissions
- Verify that policy changes were successfully deployed

## Validation

Test each persona against the protected resources.

#### Employee

Expected access:

- Internal Documentation Platform ( [image](https://github.com/coderhoades/TailscaleProject/blob/main/images/employee-docs.png) )
- Production Database ( [image](https://github.com/coderhoades/TailscaleProject/blob/main/images/employee-database.png") )

#### Privileged Contractor

Expected access:

- Internal Documentation Platform ( [image](https://github.com/coderhoades/TailscaleProject/blob/main/images/privileged-docs.png) )
- Production Database ( [image](https://github.com/coderhoades/TailscaleProject/blob/main/images/privileged-database.png) )

#### Simple Contractor

Expected access:

- Internal Documentation Platform ( [image](https://github.com/coderhoades/TailscaleProject/blob/main/images/simple-docs.png) )

Expected denied access:

- Production Database ( [image](https://github.com/coderhoades/TailscaleProject/blob/main/images/simple-database.png) )

Successful and denied access attempts should align with the policy definition.

## How it went

Overall, I was impressed by how quickly a functional environment could be assembled without needing to configure VPN infrastructure, firewall rules, or exposed ports.
 
The most interesting aspect of the project was shifting from traditional network-centric thinking toward identity-based access controls. Instead of focusing on where users are connecting from, the solution focuses on who they are and what resources they should be allowed to access. The trick will be getting Enterprise economic buyers to understand this value and use case through our champions.

The GitOps approach felt particularly relevant for enterprise environments. Managing access policies through source control provides change tracking, accountability, and a deployment workflow that most infrastructure teams are already comfortable with.

I also found value in starting with a customer problem rather than a technical feature. Speaking with a former enterprise customer helped ground the project in a realistic use case and influenced the decision to model multiple contractor personas with different access requirements.

### What I would improve with more time

If I continued this project, I would focus on making it more production-ready:

- Implement Tailscale policy tests to automatically validate access controls and prevent policy regressions.
- Migrate from legacy ACLs to the newer Grants framework.
- Replace auth keys with OAuth-based provisioning.
- Provision the full environment with Terraform, including infrastructure, applications, and Tailscale configuration.
- Add automated validation tests to CI/CD workflows.
- Integrate an enterprise identity provider and role mapping.
- Implement device posture checks and just-in-time access workflows.
- Add temporary access expiration and approval workflows for contractors.
- Expand the environment to include additional applications and user personas to better simulate a real enterprise deployment.

The current implementation demonstrates the access control model, but these additions would move the project closer to a production-grade enterprise deployment. The classic problem of "I'm having fun with this project but there's only so much time in the day". ❤️

I'm excited for the opportunity to work with the SEs and our customers to truly understand from the inside what problems we're facing in the higher customer segments.

## AI disclosure

For this project, I limited my use of AI as it was crucial for me to "get my hands dirty" directly in your docs and solutions.

When I first started the project with the goal of using Terraform to provision the environment more fully, I used AI to refresh myself on Terraform as it has been a few years. However, as the project came together, I scrapped this approach as it didn't fit within the narrative of "contractors need access to a resource that exists".

Where I did use AI for the final output:
- Tweak my Mermaid.ai flowchart (then, of course, I had to tweak again)
- Grammar check on this document
- Generate my two dummy websites for the server