# NAME

hdone - announce end of input to a handle

# SYNOPSIS

**#include** **&lt;libdill.h>**

**int hdone(int** _h_**, int64_t** _deadline_**);**

# DESCRIPTION

This function is used to inform the handle that there will be no more input. This gives it time to finish it's work and possibly inform the user when it is safe to close the handle.

For example, in case of TCP protocol handle, **hdone** sends out a FIN packet. However, it does not wait until it is acknowledged by the peer.

_deadline_ is a point in time when the operation should time out. Use the **now()** function to get your current point in time. 0 means immediate timeout, i.e., perform the operation if possible or return without blocking if not. -1 means no deadline, i.e., the call will block forever if the operation cannot be performed.

After **hdone** is called on a handle, any attempts to send more data to the handle will result in **EPIPE** error.

Handle implementation may also decide to prevent any further receiving of data and return **EPIPE** error instead. 

# RETURN VALUE

The function returns 0 on success. On error, it returns -1 and sets _errno_ to one of the following values.

# ERRORS

* **EBADF**: Not a valid handle.
* **ENOTSUP**: Operation not supported.
* **EPIPE**:  Pipe broken. Possibly, **hdone** has already been called for this channel.
* **ETIMEDOUT**: Deadline was reached.

# EXAMPLE

```c
int rc = hdone(h);
```

