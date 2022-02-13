% input:  RGB- RGB image unormelized
%         n-   number of chunnle
% 
% output: channel-normelized n channle

function channel=seperete_channle(RGB,n)
    channel=double(RGB);
    channel=channel(:,:,n);
    channel = (channel - min(channel(:)))/(max(channel(:)) - min(channel(:)));
end