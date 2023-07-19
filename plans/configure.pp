plan check24::configure (
  TargetSpec $targets
) {
  # Install Puppet agent on target(s) so that Puppet code can run
  $targets.apply_prep

  # Apply Puppet code in parallel on all defined targets
  $apply_result = apply($targets) {

    # Look up the classes array of this node from Hiera to figure out which classes
    # should be included on this particular node.
    $classes = lookup('classes', Optional[Array[String]], 'first', undef)

    # Do not fail if no classes are found
    if $classes {

      # Include each class that was found
      $classes.each |$c| {
        include $c
      }
    }
  }
}