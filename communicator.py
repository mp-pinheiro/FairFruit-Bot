import logging
import os
import socket
from threading import Thread


class Communicator:
    def _listen(instance):
        """This is a class function to check for connections in the background
        socket accept is a blockking call, this is necessary for automatically
        opening and connecting to BizHawk
        sock.setblocking(True)
        """
        instance.socket.listen()

        instance.connection, instance.address = instance.socket.accept()
        logging.info(
            "Successfully connected to Bizzhawk. Listening for commands...")

    def __init__(self, doubleSetup=False):
        self._host = os.getenv("HOST")
        self._port = int(os.getenv("PORT"))
        if doubleSetup:
            self._port += 1000

        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.bind((self._host, self._port))

        logging.info(f"Launching BizHawk Emulator using connection settings: \
                {self._host}:{self._port}.")

        thread = Thread(target=Communicator._listen,
                        args=(self, ),
                        daemon=True)
        thread.start()

    def send_data(self, data):
        data = str(data).encode("utf-8")
        self.connection.sendall(data)

    def receive_data(self):
        data = self.connection.recv(1024)
        return data

    def close(self):
        self.connection.close()
