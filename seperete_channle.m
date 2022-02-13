% input:  RGB- RGB image unormelized
%         n-   number of chunnle
% 
% output: channel-normelized n channle

function A=seperete_channle(RGB,n)
    channel=double(RGB);
    channel=channel(:,:,n);
    A = (channel - min(channel(:)))/(max(channel(:)) - min(channel(:)));
end