echo "## CREATING SELF-SIGNED CERTIFICATE ##"
#5.	Self-signed certificate creation.
# All the cert files (fxcloud.key, fxcloud.crt, fxcloud.pem, and haproxy.cfg) should be moved to /fx-security-enterprise/haproxy folder
SSL_DIR="/dev-setup/haproxy"
cp haproxy.cfg $SSL_DIR

# Let user customize certification creation with sensible defaults
echo "Please enter info to generate SSL Private Key, CSR and Certificate"
read -p "Enter Passphrase for private key: " Passphrase
read -p "Enter Common Name (The Common Name is the Host + Domain Name. It looks like "www.company.com" or "company.com"): " CommonName
read -p "Enter Country (Use the two-letter code without punctuation for country, for example: US or CA): " Country
read -p "Enter City or Locality (The Locality field is the city or town name, for example: Berkeley): " City
read -p "Enter State or Province (Spell out the state completely; do not abbreviate the state or province name, for example: California): " State
read -p "Enter Organization: " Organization
read -p "Enter Organizational Unit (This field is the name of the department or organization unit making the request): "  OrganizationalUnit

# Set our CSR variables
SUBJ="
CN="$CommonName"
C="$Country"
L="$City"
ST="$State"
O="$Organization"
OU="$OrganizationalUnit"
"
echo "## CREATING SSL DIRECTORY ##"
# Create our SSL directory in case it doesn't exist
sudo mkdir -p "$SSL_DIR"

echo "## GENERATING CERTIFICATE FILES ##"
# Generate our Private Key, CSR and Certificate
sudo openssl genrsa -out "$SSL_DIR/fxcloud.key" 2048
sudo openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/fxcloud.key" -out "$SSL_DIR/fxcloud.csr" -passin pass:"$Passphrase"
sudo openssl x509 -req -days 365 -in "$SSL_DIR/fxcloud.csr" -signkey "$SSL_DIR/fxcloud.key" -out "$SSL_DIR/fxcloud.crt"

sudo cat /dev-setup/haproxy/fxcloud.crt /dev-setup/haproxy/fxcloud.key \ | sudo tee /dev-setup/haproxy/fxcloud.pem
