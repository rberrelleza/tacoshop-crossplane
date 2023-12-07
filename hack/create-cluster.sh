civo kubernetes create demo -n 3 -s g4s.kube.medium --cluster-type k3s --region NYC1 --wait

civo k8s show demo

civo kubernetes config demo --save --switch