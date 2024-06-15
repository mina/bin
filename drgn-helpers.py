from drgn import *

def validate_skb_type10_error(prog, txqueue):
    priv = drgn.Object(prog, 'struct gve_priv', address=0xffff9a95d745c000 + 2304)

    potential_bad_skbs = []
    for i in range(0, 497):
        skb = priv.tx[1].dqo.pending_packets[i].skb
        if (skb):
            potential_bad_skbs.append(i)

    print(potential_bad_skbs)

    for skb_index in potential_bad_skbs:
        skb = priv.tx[1].dqo.pending_packets[skb_index].skb
        shinfo = cast ("struct skb_shared_info *", skb.head + skb.end)
        frag_len = 0
        for i in range(0, shinfo.nr_frags):
            frag_len += shinfo.frags[i].bv_len
        if (skb.data_len == frag_len):
            print("skb index={0} is good".format(skb_index))
        else:
            print("WRONG SKB skb_data_len={0}, frag_len={1}".format(skb.data_len, frag_len))
