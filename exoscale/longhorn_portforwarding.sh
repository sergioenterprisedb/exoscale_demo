echo ""
echo "Click on this URL once longhorn is deployed successfully: http://localhost:7000"
echo ""
kubectl port-forward deployment/longhorn-ui 7000:8000 -n longhorn-system

