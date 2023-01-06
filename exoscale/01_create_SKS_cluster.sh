exo compute security-group create sks-security-group

exo compute security-group rule add sks-security-group \
    --description "NodePort services" \
    --protocol tcp \
    --network 0.0.0.0/0 \
    --port 30000-32767

exo compute security-group rule add sks-security-group \
    --description "SKS kubelet" \
    --protocol tcp \
    --port 10250 \
    --security-group sks-security-group

exo compute security-group rule add sks-security-group \
    --description "Calico traffic" \
    --protocol udp \
    --port 4789 \
    --security-group sks-security-group



#exo compute sks nodepool add -- disk-size 20 --instance-type large --size 3 -z ch-gva-2

#exo compute sks create cluster-example \
#    --zone ch-gva-2 \
#    --service-level pro \
#    --kubernetes-version 1.25.4 \
#    --nodepool-name my-test-nodepool \
#    --nodepool-size 3 \
#    --nodepool-security-group sks-security-group

exo compute sks create cluster-example \
    --zone ch-gva-2 \
    --service-level pro \
    --kubernetes-version 1.24.8 \
    --nodepool-name my-test-nodepool \
    --nodepool-size 3 \
    --nodepool-security-group sks-security-group \
    --nodepool-disk-size 50 \
    --nodepool-instance-type large

