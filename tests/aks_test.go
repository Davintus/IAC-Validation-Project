package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAKSDeployment(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../terraform",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Validate AKS cluster name
	aksName := terraform.Output(t, terraformOptions, "name")
	assert.Equal(t, "python-app-aks", aksName)

	// Validate node count (optional)
	// nodeCount := terraform.Output(t, terraformOptions, "node_count")
	// assert.Equal(t, "2", nodeCount)
}
