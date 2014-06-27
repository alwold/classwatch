describe School do
  it 'can filter active schools' do
    FactoryGirl.create(:school, name: 'Enabled 1', disable_adding: false)
    expect(School.active.count).to eq(1)
    expect(School.active.first.name).to eq('Enabled 1')
    FactoryGirl.create(:school, name: 'Disabled 1', disable_adding: true)
    expect(School.active.count).to eq(1)
    FactoryGirl.create(:school, name: 'Disabled 2', disable_adding: true)
    expect(School.active.count).to eq(1)
    FactoryGirl.create(:school, name: 'Enabled 2', disable_adding: false)
    expect(School.active.count).to eq(2)
    names = School.active.map { |school| school.name }
    expect(names).to include('Enabled 1')
    expect(names).to include('Enabled 2')
  end
end