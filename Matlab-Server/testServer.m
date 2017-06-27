% SERVER Write a message over the specified port
% Usage - server(message, output_port, number_of_retries)
function testServer()
    import java.net.ServerSocket
    import java.io.*
    
    output_port = 6677;
    retry = 0;
    % count of photo send
    photo_count = 1;
    
    server_socket = [];
    output_socket = [];

    while true

        retry = retry + 1;

        try
            % fprintf(1, ['Try %d waiting for client to connect to this ' ...
            %             'host on port : %d\n'], retry, output_port);
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

            % operation image and return label
            img = imread(message);
            figure,imshow(img);
            %[bbox,score,label] = detect(detector,img);
            %return label
            output_stream   = output_socket.getOutputStream;
            d_output_stream = DataOutputStream(output_stream);
            %fprintf(1, 'Writing %d bytes\n', length(message))
            d_output_stream.writeBytes(num2str(photo_count));
            d_output_stream.flush;
            
            
            
            
            % output the data over the DataOutputStream
            % Convert to stream of bytes
            %output_stream   = output_socket.getOutputStream;
            %d_output_stream = DataOutputStream(output_stream);
            %fprintf(1, 'Writing %d bytes\n', length(message))
            %d_output_stream.writeBytes(num2str(photo_count));
            %fprintf(1, num2str(photo_count));
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
end