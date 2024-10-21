#!/bin/bash

# Function to confirm apply or destroy action
confirm_action() {
    local script_name=$1
    read -p "Do you want to 'apply' or 'destroy' for $script_name? (a/d): " action
    if [[ $action == "a" ]]; then
        echo "apply"
    elif [[ $action == "d" ]]; then
        echo "destroy"
    else
        echo "Invalid option. Please choose 'apply' or 'destroy'."
        confirm_action $script_name
    fi
}

# Function to execute Terraform apply or destroy
run_terraform() {
    local action=$1
    local dir=$2
    local var_file=$3

    pushd "$dir" || { echo "Directory $dir not found"; exit 1; }

    # Initialize Terraform
    terraform init -upgrade

    if [[ $action == "apply" ]]; then
        terraform plan -var-file="$var_file"
        terraform apply -var-file="$var_file" --auto-approve
        echo "$dir Apply Completed."
    else
        terraform destroy -var-file="$var_file" --auto-approve
        echo "$dir Destroy Completed."
    fi

    popd
}

# Define script configurations (name, directory, variable file)
scripts=(
    "route53_acm aws-production/route53_acm/ domain-terraform.tfvars"
    "VPC aws-production/vpc_network/ vpc-terraform.tfvars"
    "EKSCluster aws-production/eks_cluster/ eks-terraform.tfvars"
    "Karpenter aws-production/karpenter/ karpenter-terraform.tfvars"
    "Eks_utility aws-production/eks_utility/ eks-utility-terraform.tfvars"
    "Eks_utility_ingress_domain aws-production/eks_utility_ingress_domain/ eks-utility-ingress-domain-terraform.tfvars"
    "Argocd_applications aws-production/argocd-applications/ argocd-applications-terraform.tfvars"
    "Route53_records aws-production/route53_records/ route53-records-terraform.tfvars"
)

# Function to execute selected scripts
execute_script() {
    local script=$1
    local script_name=$(echo "$script" | awk '{print $1}')
    local dir=$(echo "$script" | awk '{print $2}')
    local var_file=$(echo "$script" | awk '{print $3}')

    action=$(confirm_action "$script_name")
    run_terraform "$action" "$dir" "$var_file"
}

# Function to display menu and get user choice
display_menu() {
    echo "Which scripts do you want to run?"
    for i in "${!scripts[@]}"; do
        echo "$((i + 1)). ${scripts[i]%% *}"
    done
    echo "$(( ${#scripts[@]} + 1 )). Exit"
    read -p "Enter numbers separated by commas (e.g., 1,2) or type 'all' to run all scripts: " choice
}

# Main function to handle user input
main() {
    display_menu
    if [[ $choice == "all" ]]; then
        for script in "${scripts[@]}"; do
            execute_script "$script"
        done
    elif [[ $choice =~ ^[0-9]+(,[0-9]+)*$ ]]; then
        IFS=',' read -ra selected_scripts <<< "$choice"
        for script_index in "${selected_scripts[@]}"; do
            if [[ $script_index -le ${#scripts[@]} ]]; then
                script="${scripts[$((script_index - 1))]}"
                execute_script "$script"
            else
                echo "Invalid choice: $script_index"
            fi
        done
    else
        echo "Invalid input. Please try again."
        main
    fi
}

# Start the script
main
