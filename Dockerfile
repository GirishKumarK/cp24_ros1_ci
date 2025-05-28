FROM kkhadka343/kailash-cp22:tortoisebot-ros1-gazebo

# ===== User Setup =====
ARG USERNAME=ttbot
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND=noninteractive
ENV CATKIN_WS=/home/${USERNAME}/simulation_ws

# Tell the container to use the C.UTF-8 locale for its language settings
ENV LANG C.UTF-8
SHELL ["/bin/bash", "-c"]

# ===== User Context + Workspace Setup =====
USER ${USERNAME}
WORKDIR ${CATKIN_WS}

# ===== Copy and Build =====
RUN git clone https://github.com/kailash197/cp23_ros1test_tortoisebot_waypoints.git src/tortoisebot_waypoints
RUN source /opt/ros/noetic/setup.bash \
    && catkin_make \
    && source devel/setup.bash \
    && echo "source /opt/ros/noetic/setup.bash" >> /home/${USERNAME}/.bashrc \
    && echo "source ${CATKIN_WS}/devel/setup.bash" >> /home/${USERNAME}/.bashrc

# ===== Environment Variables =====
ENV ROS_DISTRO=noetic
ENV ROS_MASTER_URI=http://gazebo_container:11311
ENV ROS_HOSTNAME=gazebo_container
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

# ===== Cleanup =====
RUN sudo rm -rf /root/.cache

# ===== Entrypoint =====
COPY --chown=${USER_UID}:${USER_GID} ./ros1_ci/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
