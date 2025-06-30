package test

import (
	"fmt"
	"os"
)

// Helper to fetch Azure credentials
func GetAzureCreds() (string, string) {
	subID := os.Getenv("ARM_SUBSCRIPTION_ID")
	clientID := os.Getenv("ARM_CLIENT_ID")
	return subID, clientID
}
