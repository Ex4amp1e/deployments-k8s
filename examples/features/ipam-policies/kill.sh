#!/bin/bash
r=1;
while true; do
  echo "Restart $r begins $(date)"
  kubectl exec -n ns-ipam-policies first-nse -- kill 1 && kubectl exec -n nsm-system nsmgr-f2nwk -c nsmgr -- pkill -9 nsmgr
  sleep 3
  kubectl wait --for=condition=ready pod -n ns-ipam-policies first-nse --timeout=10m &>/dev/null
  kubectl wait --for=condition=ready pod -n nsm-system nsmgr-f2nwk --timeout=10m &>/dev/null
  sleep 3

  i=1;
    while ((
    (i < 50)
    && $(kubectl exec -n ns-ipam-policies first-nse -- ifconfig | grep 'Mask:255.255.255.255' -c) != 4
    && $(kubectl exec -n ns-ipam-policies first-nse -- ping -c 4 172.16.100.1 | grep '4 packets transmitted, 4 packets received' -c) != 1
    && $(kubectl exec -n ns-ipam-policies first-nse -- ping -c 4 172.16.100.3 | grep '4 packets transmitted, 4 packets received' -c) != 1
    && $(kubectl exec -n ns-ipam-policies first-nse -- ping -c 4 172.16.100.5 | grep '4 packets transmitted, 4 packets received' -c) != 1
    && $(kubectl exec -n ns-ipam-policies first-nse -- ping -c 4 172.16.100.7 | grep '4 packets transmitted, 4 packets received' -c) != 1
    )); do
      echo "Restart $r, failed attempt: $i: $(date)"
      i=$((i+1));
      sleep 1;
  done
  if ((i < 50)); then
    echo "Restart $r, Conditions met after $i attempts $(date)"
    r=$((r+1));
    continue
  fi
  echo "Restart $r, Conditions failed after $i attempts. Exiting $(date)"
  break
done