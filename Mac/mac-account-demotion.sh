#!/bin/bash

IT_ADMIN="tas"

# Check if bound to AD
if dscl localhost -list . | grep -q "Active Directory"; then
    echo "Machine is domain-bound"
    DOMAIN_BOUND=true
else
    DOMAIN_BOUND=false
fi

# Get admin group members
for user in $(dscl . -read /Groups/admin GroupMembership | cut -d: -f2); do
    # Skip system and IT admin accounts
    # Get the actual username in lowercase for comparison
    user_lower=$(echo "$user" | tr '[:upper:]' '[:lower:]')
    it_admin_lower=$(echo "$IT_ADMIN" | tr '[:upper:]' '[:lower:]')
    
    if [[ "$user_lower" == "root" ]] || [[ "$user_lower" == "$it_admin_lower" ]] || [[ "$user" == _* ]]; then
        echo "Skipping: $user"
        continue
    fi
    
    # Check if it's a domain account (contains backslash or @)
    if [[ "$user" == *"\\"* ]] || [[ "$user" == *"@"* ]]; then
        echo "Found domain account in admin group: $user"
        # Demote domain user
        dscl . -delete /Groups/admin GroupMembership "$user"
    else
        echo "Demoting local user: $user"
        dscl . -delete /Groups/admin GroupMembership "$user"
    fi
done
