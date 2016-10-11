require 'net/ssh/telnet'

# Common functionality needed to access FortiMail configuration via ssh
# library and script are NOT threadsafe

class AccessPolicy

  def initialize(fortimail_address, username, password)

    # Initialize parameters
    @fortimail_address = fortimail_address
    @username = username
    @password = password

    # Make connection & fetch config
    @session = Net::SSH::Telnet.new('Host' => @fortimail_address, 'Username' => @username, 'Password' => @password)

  end

  def FortinetConfig.finalize(id)
    @session.close
  end

  protected
  def new_id
    watermark = 1
    @config.each_line do |line|
      if /^(\w)*edit/=~line
        id = line.split[1]
        watermark = id + 1 if id >= watermark
      end
    end
    return watermark
  end

end

class AccessPolicyDelivery < AccessPolicy

  def initialize(fortimail_address, username, password)
    super
    @config = @session.cmd('String' => 'show policy access-control delivery')
  end

  def add(domain, profile)
    if @config.include? domain
      #domain already there, update profile
      # isolate id
      id = nil
      @config.each_line do |line|
        if /^(\w)*edit/=~line
          id = line.split[1]
        elsif /^(\w)*set recipient-pattern/=~line
          break if line.split[2] == domain
        end
      end
      # last id should match the domain entry now, update it
      @session.cmd('config policy access-control delivery')
      @session.cmd("edit #{id}")
      @session.cmd("set tls-profile #{profile}")
      @session.cmd('next')      
      @session.cmd('end')
    else
      #add domain entry
      id = new_id
      @session.cmd('config policy access-control delivery')
      @session.cmd("edit #{id}")
      @session.cmd("set recipient-pattern #{domain}")
      @session.cmd("set tls-profile #{profile}")
      # last policy is default catchall, we need to be one notch higher
      @session.cmd("move #{id} up")
      @session.cmd('next')
      @session.cmd('end')
    end
  end

  def remove(domain)
    if @config.include? domain
      # isolate id
      id = nil
      @config.each_line do |line|
        if /^(\w)*edit/=~line
          id = line.split[1]
        elsif /^(\w)*set recipient-pattern/=~line
          break if line.split[2] == domain
        end
      end
      # last id should match the domain entry now, remove it
      @session.cmd('config policy access-control delivery')
      @session.cmd("delete #{id}")
      @session.cmd('end')
    end
  end

end

class AccessPolicyReceive < AccessPolicy

  def initialize(fortimail_address, username, password)
    super
    @config = @session.cmd('String' => 'show policy access-control receive')
  end

  def add(domain, profile)
    if @config.include? domain
      #domain already there, update profile
      # isolate id
      id = nil
      @config.each_line do |line|
        if /^(\w)*edit/=~line
          id = line.split[1]
        elsif /^(\w)*set sender-pattern/=~line
          break if line.split[2] == domain
        end
      end
      # last id should match the domain entry now, update it
      @session.cmd('config policy access-control receive')
      @session.cmd("edit #{id}")
      @session.cmd("set tls-profile #{profile}")
      @session.cmd('next')
      @session.cmd('end')
    else
      #add domain entry
      id = new_id
      @session.cmd('config policy access-control receive')
      @session.cmd("edit #{id}")
      @session.cmd("set sender-pattern #{domain}")
      @session.cmd("set tls-profile #{profile}")
      @session.cmd('set action relay')
      # last policy is default catchall, we need to be one notch higher
      @session.cmd("move #{id} up")
      @session.cmd('next')
      @session.cmd('end')
    end
  end

  def remove(domain)
    if @config.include? domain
      # isolate id
      id = nil
      @config.each_line do |line|
        if /^(\w)*edit/=~line
          id = line.split[1]
        elsif /^(\w)*set sender-pattern/=~line
          break if line.split[2] == domain
        end
      end
      # last id should match the domain entry now, remove it
      @session.cmd('config policy access-control receive')
      @session.cmd("delete #{id}")
      @session.cmd('end')
    end
  end

end
