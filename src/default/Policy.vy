# pragma version ^0.4.0

interface Kernel:
    def getModuleForKeycode(keycode: bytes5) -> address: view

interface Policy:
    def isActive() -> bool: view
    def configureDependencies() -> DynArray[bytes5, 8]: nonpayable
    def requestPermissions() -> DynArray[Permissions, 8]: nonpayable

implements: Policy

struct Permissions:
    keycode: bytes5
    function: bytes4

kernel: Kernel
isActive: public(bool)

@external
def changeKernel(new_kernel: address) -> bool:
    """
    @notice Change the kernel address
    @dev Only callable by the kernel
    @return True if kernel changed successfully
    """
    self._onlyKernel()
    self.kernel = Kernel(new_kernel)
    return True

@internal
def _onlyKernel() -> bool:
    """
    @dev Internal function to check if caller is the kernel
    @return True if caller is kernel
    """
    assert msg.sender == self.kernel.address, "!KERNEL"
    return True

@external
def configureDependencies() -> DynArray[bytes5, 8]:
    """
    @notice Configure dependencies for the policy
    @dev Should be overridden by the module importer
    """
    deps: DynArray[bytes5, 8] = []
    return deps

@external
def requestPermissions() -> DynArray[Permissions, 8]:
    """
    @notice Request permissions for the policy
    @dev Should be overridden by the module importer
    """
    perms: DynArray[Permissions, 8] = []
    return perms
