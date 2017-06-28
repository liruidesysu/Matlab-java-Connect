# Matlab-java-Connect
本例子是有高成英老师指导的软件工程高级实训项目《基于深度学习的多特征融合定位系统开发》中个人负责的模板中的一部分。

一、Matlab端内嵌java代码，通过java调用socket实现通信，下面是简单的Matlab中TCP/IP socket通信例子。
  Matlab作为服务端代码
  % CLIENT connect to a server and read a message
  %
  % Usage - message = client(host, port, number_of_retries)
function message = client(host, port, number_of_retries)

    import java.net.Socket
    import java.io.*

    if (nargin < 3)
        number_of_retries = 20; % set to -1 for infinite
    end
    
    retry        = 0;
    input_socket = [];
    message      = [];

    while true

        retry = retry + 1;
        if ((number_of_retries > 0) && (retry > number_of_retries))
            fprintf(1, 'Too many retries\n');
            break;
        end
        
        try
            fprintf(1, 'Retry %d connecting to %s:%d\n', ...
                    retry, host, port);

            % throws if unable to connect
            input_socket = Socket(host, port);

            % get a buffered data input stream from the socket
            input_stream   = input_socket.getInputStream;
            d_input_stream = DataInputStream(input_stream);

            fprintf(1, 'Connected to server\n');

            % read data from the socket - wait a short time first
            pause(0.5);
            bytes_available = input_stream.available;
            fprintf(1, 'Reading %d bytes\n', bytes_available);
            
            message = zeros(1, bytes_available, 'uint8');
            for i = 1:bytes_available
                message(i) = d_input_stream.readByte;
            end
            
            message = char(message);
            
            % cleanup
            input_socket.close;
            break;
            
        catch
            if ~isempty(input_socket)
                input_socket.close;
            end

            % pause before retrying
            pause(1);
        end
    end
end

  Matlab客户端代码
  ERVER Write a message over the specified port
% 
% Usage - server(message, output_port, number_of_retries)
function server(message, output_port, number_of_retries)

    import java.net.ServerSocket
    import java.io.*

    if (nargin < 3)
        number_of_retries = 20; % set to -1 for infinite
    end
    retry             = 0;

    server_socket  = [];
    output_socket  = [];

    while true

        retry = retry + 1;

        try
            if ((number_of_retries > 0) && (retry > number_of_retries))
                fprintf(1, 'Too many retries\n');
                break;
            end

            fprintf(1, ['Try %d waiting for client to connect to this ' ...
                        'host on port : %d\n'], retry, output_port);

            % wait for 1 second for client to connect server socket
            server_socket = ServerSocket(output_port);
            server_socket.setSoTimeout(1000);

            output_socket = server_socket.accept;

            fprintf(1, 'Client connected\n');

            output_stream   = output_socket.getOutputStream;
            d_output_stream = DataOutputStream(output_stream);

            % output the data over the DataOutputStream
            % Convert to stream of bytes
            fprintf(1, 'Writing %d bytes\n', length(message))
            d_output_stream.writeBytes(char(message));
            d_output_stream.flush;
            
            % clean up
            server_socket.close;
            output_socket.close;
            break;
            
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


  实现java客户端与matlab服务器之间的简单socket通信，并通过java传送的图片地址在matlab服务端显示出来。
