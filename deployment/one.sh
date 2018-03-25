npm install -g now
echo "deploying..."
URL=$(now --docker --public -t $NOW_TOKEN)
echo "go to $URL"
curl --silent -L $URL