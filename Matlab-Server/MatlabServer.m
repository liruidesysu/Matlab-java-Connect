% SERVER Write a message over the specified port
% Usage - server(message, output_port, number_of_retries)


import java.net.ServerSocket
import java.io.*

output_port = 6677;
retry = 0;
% count of photo send
photo_count = 1;

server_socket = [];
output_socket = [];
%bbox = [];
%score = [];
%label = 0;


fprintf(1, 'Matlab Server Started.\n');
detectorForSixtyFiveForScaled2_1 = load('detectorForSixtyFiveForScaled2_1.mat');
detectorForSixtyFiveForScaled2_1 = detectorForSixtyFiveForScaled2_1.detectorForSixtyFiveForScaled2_1;
fprintf(1, 'Loaded model successfully.\n');

while true
    
    retry = retry + 1;
    
    try
        % wait for 1 second for client to connect server socket
        server_socket = ServerSocket(output_port);
        server_socket.setSoTimeout(1000);
        
        % waiting for connection
        output_socket = server_socket.accept;
        
        fprintf(1, 'Client connected\n');
        
        % get a buffered data input stream from the socket
        input_stream = output_socket.getInputStream;
        d_input_stream = DataInputStream(input_stream);
        pause(0.5);
        bytes_available = input_stream.available;
        %fprintf(1, 'Reading %d bytes\n', bytes_available);
        message = zeros(1, bytes_available, 'uint8');
        for i = 1:bytes_available
            message(i) = d_input_stream.readByte;
        end
        message = char(message);
        fprintf(1, '%s', message);
        
        %img = imread(message);
        %[bbox, score, label] = detect(newDetector3, img);
        %detectedImg=insertShape(img, 'Rectangle', bbox);
        %figure,imshow(img);
        
        % Parse string 
        photoUrl = regexp(message, '\|', 'split');
        % get size of photoUrl
        col=size(photoUrl, 2);
        % Initialization labelOut = ""
        labelOut = strcat('','');
        isException = 0;
        
        %%%%%%%%%%%%%%%%%%%%JUST FOR TEST%%%%%%%
        %for imgNum = 1:col
            %if isequal(imgNum,3)
                %labelOut = strcat(labelOut,char(photoUrl(imgNum)));
                %fprintf(1, '%s\n', labelOut);
            %else
                %labelOut = strcat(labelOut,char(photoUrl(imgNum)));
                %fprintf(1, '%s\n', labelOut);
                %labelOut = strcat(labelOut,'#################');
                %fprintf(1, '%s\n', labelOut);
            %end
        %end
        %output_stream  = output_socket.getOutputStream;
        %d_output_stream = DataOutputStream(output_stream);
        %d_output_stream.writeBytes(labelOut);
        %d_output_stream.flush;
        %%%%%%%%%%%%%%%%%%%%%THE END%%%%%%%%%%%%%%
        
        output_stream  = output_socket.getOutputStream;
        d_output_stream = DataOutputStream(output_stream);
        
        % Parse string 
        % if img or label equel Null, return -1
        % else return label1:label2:label3
        for imgNum = 1:col
            if isempty(char(photoUrl(imgNum))) == 1
                fprintf(1, '%s', 'Null image');
                %d_output_stream.writeBytes('-1');
                isException = 1;
                break;
            else
                %   fprintf(1, '%s', char(photoUrl(imgNum)));
                % read image and make size of 128x228
                img = imread(char(photoUrl(imgNum)));
                img = imresize(img, [128, 228]);
                %figure,imshow(img);
                
                % get label
                [bbox,score,label] = detect(detectorForSixtyFiveForScaled2_1,img);
                if isempty(label) == 1
                    %d_output_stream.writeBytes('-1');
                    isException = 1;
                    break;
                else
                    [score, idx] = max(score);
                    label = label(idx, :);
                    label = char(label);
                    % form of label is 'b''label'
                    label = label(2:end);
                    
                    % make return label form of label1:label2:label3
                    if isequal(imgNum,3)
                        labelOut = strcat(labelOut,label);
                    else
                        labelOut = strcat(labelOut,label);
                        labelOut = strcat(labelOut,'|');
                    end
                    fprintf(1, 'the labe is  %s\n', labelOut);
                end
            end
            %labelOut = [];
        end
        
        if isequal(isException,1)
            d_output_stream.writeBytes('-1');
        else
            d_output_stream.writeBytes(labelOut);
        end
        d_output_stream.flush;
        
        % output the data over the DataOutputStream
        % Convert to stream of bytes
        %output_stream   = output_socket.getOutputStream;
        %d_output_stream = DataOutputStream(output_stream);
        %fprintf(1, 'Writing %d bytes\n', length(message))
        %d_output_stream.writeBytes(num2str(photo_count));
        %d_output_stream.flush;
        
        % photo_count++
        photo_count = photo_count + 1;
        
        % clean up
        server_socket.close;
        output_socket.close;
        
    catch
        if ~isempty(server_socket)
            server_socket.close
        end
        
        if ~isempty(output_socket)
            output_socket.close
        end
        
        % pause before retrying
        pause(1);
    end
end
