/*
 * Copyright 2008, The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); 
 * you may not use this file except in compliance with the License. 
 * You may obtain a copy of the License at 
 *
 *     http://www.apache.org/licenses/LICENSE-2.0 
 *
 * Unless required by applicable law or agreed to in writing, software 
 * distributed under the License is distributed on an "AS IS" BASIS, 
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
 * See the License for the specific language governing permissions and 
 * limitations under the License.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

#include <sys/socket.h>
#include <sys/select.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <netdb.h>

#include <linux/if.h>
#include <linux/if_ether.h>
#include <linux/if_arp.h>
#include <linux/netlink.h>
#include <linux/route.h>
#include <linux/ipv6_route.h>
#include <linux/rtnetlink.h>
#include <linux/sockios.h>

#include "ifc.h"

#ifdef ANDROID
#define LOG_TAG "NetUtils"
#include <cutils/log.h>
#include <cutils/properties.h>
#else
#include <stdio.h>
#include <string.h>
#define ALOGD printf
#define ALOGW printf
#endif

static int ifc_ctl_sock6 = -1;

#define DBG 0

int ifc_act_on_ipv6_route(int action, const char *ifname, struct in6_addr dst, int prefix_length,
      struct in6_addr gw)
{
    struct in6_rtmsg rtmsg;
    int result;
    int ifindex;

    memset(&rtmsg, 0, sizeof(rtmsg));

    ifindex = if_nametoindex(ifname);
    if (ifindex == 0) {
        printerr("if_nametoindex() failed: interface %s\n", ifname);
        return -ENXIO;
    }

    rtmsg.rtmsg_ifindex = ifindex;
    rtmsg.rtmsg_dst = dst;
    rtmsg.rtmsg_dst_len = prefix_length;
    rtmsg.rtmsg_flags = RTF_UP;

    if (prefix_length == 128) {
        rtmsg.rtmsg_flags |= RTF_HOST;
    }

    if (memcmp(&gw, &in6addr_any, sizeof(in6addr_any))) {
        rtmsg.rtmsg_flags |= RTF_GATEWAY;
        rtmsg.rtmsg_gateway = gw;
    }

    ifc_init6();

    if (ifc_ctl_sock6 < 0) {
        return -errno;
    }

    result = ioctl(ifc_ctl_sock6, action, &rtmsg);
    if (result < 0) {
        if (errno == EEXIST) {
            result = 0;
        } else {
            result = -errno;
        }
    }
    ifc_close6();
    return result;
}

int ifc_act_on_route(int action, const char *ifname, const char *dst, int prefix_length,
        const char *gw)
{
    int ret = 0;
    struct sockaddr_in ipv4_dst, ipv4_gw;
    struct sockaddr_in6 ipv6_dst, ipv6_gw;
    struct addrinfo hints, *addr_ai, *gw_ai;

    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;  /* Allow IPv4 or IPv6 */
    hints.ai_flags = AI_NUMERICHOST;

    ret = getaddrinfo(dst, NULL, &hints, &addr_ai);

    if (ret != 0) {
        printerr("getaddrinfo failed: invalid address %s\n", dst);
        return -EINVAL;
    }

    if (gw == NULL || (strlen(gw) == 0)) {
        if (addr_ai->ai_family == AF_INET6) {
            gw = "::";
        } else if (addr_ai->ai_family == AF_INET) {
            gw = "0.0.0.0";
        }
    }

    if (((addr_ai->ai_family == AF_INET6) && (prefix_length < 0 || prefix_length > 128)) ||
            ((addr_ai->ai_family == AF_INET) && (prefix_length < 0 || prefix_length > 32))) {
        printerr("ifc_add_route: invalid prefix length");
        freeaddrinfo(addr_ai);
        return -EINVAL;
    }

    ret = getaddrinfo(gw, NULL, &hints, &gw_ai);
    if (ret != 0) {
        printerr("getaddrinfo failed: invalid gateway %s\n", gw);
        freeaddrinfo(addr_ai);
        return -EINVAL;
    }

    if (addr_ai->ai_family != gw_ai->ai_family) {
        printerr("ifc_add_route: different address families: %s and %s\n", dst, gw);
        freeaddrinfo(addr_ai);
        freeaddrinfo(gw_ai);
        return -EINVAL;
    }

    if (addr_ai->ai_family == AF_INET6) {
        memcpy(&ipv6_dst, addr_ai->ai_addr, sizeof(struct sockaddr_in6));
        memcpy(&ipv6_gw, gw_ai->ai_addr, sizeof(struct sockaddr_in6));
        ret = ifc_act_on_ipv6_route(action, ifname, ipv6_dst.sin6_addr,
                prefix_length, ipv6_gw.sin6_addr);
    } else if (addr_ai->ai_family == AF_INET) {
        memcpy(&ipv4_dst, addr_ai->ai_addr, sizeof(struct sockaddr_in));
        memcpy(&ipv4_gw, gw_ai->ai_addr, sizeof(struct sockaddr_in));
        ret = ifc_act_on_ipv4_route(action, ifname, ipv4_dst.sin_addr,
                prefix_length, ipv4_gw.sin_addr);
    } else {
        printerr("ifc_add_route: getaddrinfo returned un supported address family %d\n",
                  addr_ai->ai_family);
        ret = -EAFNOSUPPORT;
    }

    freeaddrinfo(addr_ai);
    freeaddrinfo(gw_ai);
    return ret;
}

int ifc_add_ipv4_route(const char *ifname, struct in_addr dst, int prefix_length,
      struct in_addr gw)
{
    int i =ifc_act_on_ipv4_route(SIOCADDRT, ifname, dst, prefix_length, gw);
    if (DBG) printerr("ifc_add_ipv4_route(%s, xx, %d, xx) = %d", ifname, prefix_length, i);
    return i;
}

int ifc_add_ipv6_route(const char *ifname, struct in6_addr dst, int prefix_length,
      struct in6_addr gw)
{
    return ifc_act_on_ipv6_route(SIOCADDRT, ifname, dst, prefix_length, gw);
}

int ifc_add_route(const char *ifname, const char *dst, int prefix_length, const char *gw)
{
    int i = ifc_act_on_route(SIOCADDRT, ifname, dst, prefix_length, gw);
    if (DBG) printerr("ifc_add_route(%s, %s, %d, %s) = %d", ifname, dst, prefix_length, gw, i);
    return i;
}

int ifc_remove_route(const char *ifname, const char*dst, int prefix_length, const char *gw)
{
    return ifc_act_on_route(SIOCDELRT, ifname, dst, prefix_length, gw);
}
