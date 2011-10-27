class Author < ActiveRecord::Base
  has_and_belongs_to_many :diagrams

  validates_presence_of :name
  validates_format_of :name, with: /^(.+)\s+(\S+)$/, 
    message: 'must consist of given names and family name.'

  cattr_reader :per_page
  @@per_page = 99
  
  before_save :generate_code

  attr_accessible :name

protected
#########################################

  def generate_code
    
    return unless self.code.blank?
    
    nname = self.name.mb_chars.normalize(:kd).gsub(/[^\x20-\x7F]/,'').upcase.to_s
    nname.gsub!(/\(.*\)/, '') # no parens
    nname.gsub!(/ MC/, ' ') # no McSomeone
    nname.gsub!(/ O\'/, ' ') # no O'Anybody
    nname.gsub!(/ SR\.?$| JR\.?$/, '') # no sr or jr
    nname.strip!
    nname =~ /^(.+)\s+(\S+)$/
    names, family = $1[0,1], $2[0,2]
    
    @others = Author
      .where{ (code != nil) & (code =~ "#{family}%#{names}") }

    while true
      trycode = family + random_code + names
      unless @others.find {|i| i.code == trycode}
        self.code = trycode
        # logger.info "*** #{trycode} ***"
        break
      end
    end
  end
  
  def random_code
    digit8 = ''
    limit = @others.size.to_s(8).size # how many digits we need?
    limit.times do
      digit8 += (2 + rand(8)).to_s
    end
    return digit8
  end

end
