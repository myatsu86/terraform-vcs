# Project architecture diagram

The diagram reflects the Terraform configuration and default variables in this repository, rather than deployed resource state.

- `../images/architecture.excalidraw`: editable diagram, with library vector elements embedded.
- `../images/architecture-excalidraw.svg`: scalable preview.
- `../images/architecture-excalidraw.png`: rendered preview.
- `project-icons.excalidrawlib`: reusable selection of the original library items; import through Excalidraw's library menu.

Regenerate the editable diagram and SVG with `python3 docs/diagrams/generate_architecture.py` from the repository root. Render the SVG to PNG using an SVG renderer.

## Icon attribution

Original library elements from the [Excalidraw libraries repository](https://github.com/excalidraw/excalidraw-libraries):

- [AWS Architecture Icons](https://github.com/excalidraw/excalidraw-libraries/blob/main/libraries/childishgirl/aws-architecture-icons.excalidrawlib) by Anna Pastushko: EC2, VPC, internet gateway, NAT gateway, route table.
- [HashiCorp](https://github.com/excalidraw/excalidraw-libraries/blob/main/libraries/mattias-fjellstrom/hashicorp.excalidrawlib) by Mattias Fjellström: Terraform logo.
- [Technology Logos](https://github.com/excalidraw/excalidraw-libraries/blob/main/libraries/maeddes/technology-logos.excalidrawlib) by Matthias Haeussler: Git logo.
- [Architecture diagram components](https://github.com/excalidraw/excalidraw-libraries/blob/main/libraries/anna-pastushko/architecture-diagram-components.excalidrawlib) by Anna Pastushko: device, public subnet, private subnet.

The reusable library preserves each original item's vector geometry and style. Diagram icons are scaled and grouped, with redundant labels omitted. SVG previews use the same geometry with solid fills instead of Excalidraw hatching. Product names and logos belong to their respective owners.

## Updated reference-style workflow

`generate_updated_workflow.py` produces `../images/Terraform_VCS_Workflow_Updated.{png,svg,excalidraw}` (PNG requires rendering the SVG). This version follows the original `Terraform_VCS_Workflow.png` three-column layout and adds the Security workspace, run triggers, OPA checking the Security plan, two Ubuntu services, and private egress via the NAT gateway. Run triggers and policy attachment represent the HCP UI setup described by the project owner; Terraform files define the AWS resources and remote-state readers. The original reference image is preserved.
